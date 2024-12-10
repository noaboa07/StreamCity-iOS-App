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
                .accessibilityLabel("Email input field")
                .accessibilityValue(email.isEmpty ? "Empty" : email)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .accessibilityLabel("Password input field")
                .accessibilityValue(password.isEmpty ? "Empty" : "Password entered")

            Button(action: {
                if validateInput() {
                    isLoading = true
                    signIn()
                }
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
                        .accessibilityLabel("Log in button")
                }
            }
            .disabled(isLoading) // Disable button when loading

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .accessibilityLabel("Error message")
                    .accessibilityValue(errorMessage)
            }

            Spacer()

            NavigationLink("Don't have an account? Sign Up", destination: SignUpView(isLoggedIn: $isLoggedIn))
                .padding()
        }
        .padding()
        .navigationTitle("Log In")
    }

    private func validateInput() -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please fill in both fields."
            return false
        }
        return true
    }

    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                handleAuthError(error)
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

    private func handleAuthError(_ error: Error) {
        if let authError = error as NSError? {
            switch authError.code {
            case AuthErrorCode.wrongPassword.rawValue:
                errorMessage = "Incorrect password. Please try again."
            case AuthErrorCode.userNotFound.rawValue:
                errorMessage = "No account found with this email."
            case AuthErrorCode.invalidEmail.rawValue:
                errorMessage = "Invalid email format."
            default:
                errorMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
}
