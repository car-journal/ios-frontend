//
//  LoginView.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 19/12/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isValid: Bool = false
    
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 20) {
            
            Text("Welcome Back")
                .font(.largeTitle)
                .bold()
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .onChange(of: email) { _, newValue in
                    isValid = isValidEmail(newValue)
                }

            if !isValid && !email.isEmpty {
                Text("Invalid email address")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            AppButton(
                title: "Login",
                isLoading: viewModel.isLoading,
                isDisabled: !isValid || password.isEmpty
            ) {
                await viewModel.login(email: email, password: password)
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
    }
}

func isValidEmail(_ email: String) -> Bool {
    let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
}

#Preview {
    LoginView(viewModel: LoginViewModel(authManager: AuthManager(),repository: MockAuthRepository()))
}
