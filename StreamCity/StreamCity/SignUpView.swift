//
//  SignUpView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoading = false // New state for loading indicator
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .accessibilityLabel("Email input field")

            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .accessibilityLabel("Password input field")

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                if validateInput() {
                    isLoading = true
                    signUp()
                }
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                        .accessibilityLabel("Sign up button")
                }
            }
            .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("Sign Up")
    }

    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false // Stop loading indicator
            if let error = error {
                errorMessage = "Error: \(error.localizedDescription)"
            } else if let result = result {
                addUserToFirestore(uid: result.user.uid, email: email)
                isLoggedIn = true
            }
        }
    }

    private func validateInput() -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please fill in both fields."
            return false
        }
        
        if !isValidEmail(email) {
            errorMessage = "Invalid email format."
            return false
        }
        
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters long."
            return false
        }
        
        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    private func addUserToFirestore(uid: String, email: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData([
            "email": email,
            "createdAt": Timestamp()
        ]) { error in
            if let error = error {
                print("Error adding user to Firestore: \(error.localizedDescription)")
            }
        }
    }
}
