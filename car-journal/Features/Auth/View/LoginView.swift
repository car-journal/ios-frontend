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
    @State private var isValid = false

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.cjBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundStyle(Color.appShade2)

                    Text("Car Journal")
                        .font(.appLargeTitle)
                        .foregroundStyle(Color.cjTextPrimary)

                    Text("Track every fill-up, every kilometre.")
                        .font(.appSubheadline)
                        .foregroundStyle(Color.cjTextSecondary)
                }
                .padding(.top, 72)
                .padding(.bottom, 48)

                // Form card
                VStack(spacing: 16) {
                    // Email
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.appCaption)
                            .foregroundStyle(Color.cjTextSecondary)
                            .padding(.leading, 4)

                        TextField("you@example.com", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .font(.appBody)
                            .foregroundStyle(Color.cjTextPrimary)
                            .appInput()
                            .onChange(of: email) { _, newValue in
                                isValid = isValidEmail(newValue)
                            }

                        if !isValid && !email.isEmpty {
                            Label("Invalid email address", systemImage: "exclamationmark.circle.fill")
                                .font(.appCaption)
                                .foregroundStyle(Color.appNegative)
                                .padding(.leading, 4)
                        }
                    }

                    // Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.appCaption)
                            .foregroundStyle(Color.cjTextSecondary)
                            .padding(.leading, 4)

                        SecureField("••••••••", text: $password)
                            .font(.appBody)
                            .foregroundStyle(Color.cjTextPrimary)
                            .appInput()
                    }

                    if let error = viewModel.errorMessage {
                        Label(error, systemImage: "xmark.circle.fill")
                            .font(.appCaption)
                            .foregroundStyle(Color.appNegative)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 4)
                    }

                    AppButton(
                        title: "Sign In",
                        isLoading: viewModel.isLoading,
                        isDisabled: !isValid || password.isEmpty
                    ) {
                        await viewModel.login(email: email, password: password)
                    }
                    .padding(.top, 4)
                }
                .padding(24)
                .appCard()
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }
}

func isValidEmail(_ email: String) -> Bool {
    let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
}

#Preview {
    LoginView(viewModel: LoginViewModel(authManager: AuthManager(), repository: MockAuthRepository()))
}
