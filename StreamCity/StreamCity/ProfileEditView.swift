//
//  ProfileEditView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import UIKit

struct ProfileEditView: View {
    @Binding var username: String
    @Binding var profileImage: String
    @State private var newUsername: String
    @State private var showSaveConfirmation = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil

    init(username: Binding<String>, profileImage: Binding<String>) {
        _username = username
        _profileImage = profileImage
        _newUsername = State(initialValue: username.wrappedValue)
    }

    var body: some View {
        VStack {
            Text("Edit Profile")
                .font(.largeTitle)
                .padding()

            // Username Edit
            HStack {
                Text("Username:")
                TextField("Enter new username", text: $newUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            // Profile Image Edit
            VStack {
                Text("Profile Image:")
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                } else if !profileImage.isEmpty {
                    AsyncImage(url: URL(string: profileImage)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 150, height: 150)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                        case .success(let loadedImage):
                            loadedImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Text("No profile image set")
                        .frame(width: 150, height: 150)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                }

                Button("Select Photo") {
                    showImagePicker = true
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                .foregroundColor(.blue)
            }

            Button("Save Changes") {
                saveProfileChanges()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
            .foregroundColor(.blue)
            .alert(isPresented: $showSaveConfirmation) {
                Alert(
                    title: Text("Success"),
                    message: Text("Your profile has been updated."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            PhotoPicker(isPresented: $showImagePicker, selectedImage: $selectedImage)
        }
        .onAppear {
            loadProfileImage()
        }
    }

    private func loadProfileImage() {
        guard let user = Auth.auth().currentUser else { return }
        
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imagePath = documentsPath.appendingPathComponent("\(user.uid)_profile.jpg")
        
        if fileManager.fileExists(atPath: imagePath.path) {
            if let image = UIImage(contentsOfFile: imagePath.path) {
                profileImage = imagePath.absoluteString
            } else {
                print("Failed to load image from path: \(imagePath.path)")
            }
        } else {
            print("Image not found at path: \(imagePath.path)")
        }
    }

    private func saveProfileChanges() {
        guard !newUsername.isEmpty || selectedImage != nil else {
            return
        }

        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
            let userRef = db.collection("users").document(user.uid)
            var updates: [String: Any] = [:]

            // Update username if changed
            if !newUsername.isEmpty && newUsername != username {
                updates["username"] = newUsername
            }
            
            // Save the image locally and create a usable URL
            if let image = selectedImage {
                let fileManager = FileManager.default
                let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                let imagePath = documentsPath.appendingPathComponent("\(user.uid)_profile.jpg")

                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    do {
                        try imageData.write(to: imagePath)
                        updates["profileImage"] = imagePath.absoluteString
                    } catch {
                        print("Error saving image locally: \(error)")
                    }
                }
            }

            userRef.updateData(updates) { error in
                if let error = error {
                    print("Error updating profile: \(error.localizedDescription)")
                } else {
                    username = newUsername.isEmpty ? username : newUsername
                    profileImage = updates["profileImage"] as? String ?? profileImage
                    showSaveConfirmation = true
                    print("Profile updated successfully")
                }
            }
        }
    }
}
