//
//  LoginView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoading = false // For showing a loading indicator
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)

            Button(action: {
                if email.isEmpty || password.isEmpty {
                    errorMessage = "Please fill in both fields."
                    return
                }
                isLoading = true
                signIn()
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Text("Log In")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            .disabled(isLoading) // Disable button when loading

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()

            NavigationLink("Don't have an account? Sign Up", destination: SignUpView(isLoggedIn: $isLoggedIn))
                .padding()
        }
        .padding()
        .navigationTitle("Log In")
    }

    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                errorMessage = "Error: \(error.localizedDescription)"
                return
            }

            // Sign-in successful
            if result != nil {
                isLoggedIn = true // Update isLoggedIn state
            } else {
                errorMessage = "An unknown error occurred. Please try again."
            }
        }
    }
}
