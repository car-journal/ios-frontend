//
//  RegisterView.swift
//  car-journal
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel: RegisterViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedGender: GenderOption = .unspecified
    @State private var isEmailValid = false

    init(repository: AuthRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: RegisterViewModel(repository: repository))
    }

    enum GenderOption: String, CaseIterable {
        case unspecified = "Prefer not to say"
        case male        = "Male"
        case female      = "Female"

        var boolValue: Bool? {
            switch self {
            case .male:        return true
            case .female:      return false
            case .unspecified: return nil
            }
        }
    }

    var body: some View {
        ZStack {
            Color.cjBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 44, weight: .semibold))
                            .foregroundStyle(Color.appShade2)
                        Text("Create Account")
                            .font(.appLargeTitle)
                            .foregroundStyle(Color.cjTextPrimary)
                        Text("Join Car Journal today.")
                            .font(.appSubheadline)
                            .foregroundStyle(Color.cjTextSecondary)
                    }
                    .padding(.top, 56)
                    .padding(.bottom, 36)

                    // Form
                    VStack(spacing: 20) {
                        // Required fields
                        formSection("Account", systemImage: "envelope.fill") {
                            labeledField("Email") {
                                TextField("you@example.com", text: $email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .font(.appBody)
                                    .foregroundStyle(Color.cjTextPrimary)
                                    .appInput()
                                    .onChange(of: email) { _, v in isEmailValid = isValidEmail(v) }
                                if !isEmailValid && !email.isEmpty {
                                    Label("Invalid email address", systemImage: "exclamationmark.circle.fill")
                                        .font(.appCaption)
                                        .foregroundStyle(Color.appNegative)
                                        .padding(.leading, 4)
                                }
                            }
                            labeledField("Password") {
                                SecureField("Min. 6 characters", text: $password)
                                    .font(.appBody).foregroundStyle(Color.cjTextPrimary).appInput()
                            }
                            labeledField("Confirm Password") {
                                SecureField("Repeat password", text: $confirmPassword)
                                    .font(.appBody).foregroundStyle(Color.cjTextPrimary).appInput()
                                if !confirmPassword.isEmpty && password != confirmPassword {
                                    Label("Passwords do not match", systemImage: "exclamationmark.circle.fill")
                                        .font(.appCaption).foregroundStyle(Color.appNegative).padding(.leading, 4)
                                }
                            }
                        }

                        // Profile fields
                        formSection("Profile", systemImage: "person.fill") {
                            labeledField("First Name") {
                                TextField("Required", text: $firstName)
                                    .textInputAutocapitalization(.words)
                                    .font(.appBody).foregroundStyle(Color.cjTextPrimary).appInput()
                            }
                            labeledField("Last Name (optional)") {
                                TextField("Optional", text: $lastName)
                                    .textInputAutocapitalization(.words)
                                    .font(.appBody).foregroundStyle(Color.cjTextPrimary).appInput()
                            }
                            labeledField("Gender (optional)") {
                                Menu {
                                    ForEach(GenderOption.allCases, id: \.rawValue) { option in
                                        Button {
                                            selectedGender = option
                                        } label: {
                                            HStack {
                                                Text(option.rawValue)
                                                if selectedGender == option {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedGender.rawValue)
                                            .font(.appBody)
                                            .foregroundStyle(selectedGender == .unspecified ? Color.cjTextSecondary : Color.cjTextPrimary)
                                        Spacer()
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.appCaption).foregroundStyle(Color.cjTextSecondary)
                                    }
                                    .appInput()
                                }
                            }
                        }

                        if let error = viewModel.errorMessage {
                            Label(error, systemImage: "xmark.circle.fill")
                                .font(.appCaption).foregroundStyle(Color.appNegative)
                                .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 4)
                        }

                        AppButton(
                            title: "Create Account",
                            isLoading: viewModel.isLoading,
                            isDisabled: !isEmailValid || password.isEmpty || firstName.isEmpty
                        ) {
                            await viewModel.register(
                                email: email,
                                password: password,
                                confirmPassword: confirmPassword,
                                firstName: firstName,
                                lastName: lastName,
                                gender: selectedGender.boolValue,
                                dateOfBirth: nil
                            )
                        }

                        // Back to login
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: 4) {
                                Text("Already have an account?")
                                    .foregroundStyle(Color.cjTextSecondary)
                                Text("Sign In")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.cjPrimary)
                            }
                            .font(.appSubheadline)
                        }
                        .padding(.top, 4)
                    }
                    .padding(24)
                    .appCard()
                    .padding(.horizontal, 24)

                    Spacer().frame(height: 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Sign In")
                    }
                    .font(.appSubheadline)
                    .foregroundStyle(Color.cjPrimary)
                }
            }
        }
        .onChange(of: viewModel.didRegisterSuccessfully) { _, success in
            guard success else { return }
            dismiss()
        }
    }

    // MARK: - Helpers
    private func formSection<Content: View>(
        _ title: String,
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: systemImage).font(.appSubheadline).foregroundStyle(Color.appShade2)
                Text(title).font(.appHeadline).foregroundStyle(Color.cjTextPrimary)
            }.padding(.leading, 4)
            VStack(spacing: 12) { content() }.padding(16).appCard()
        }
    }

    private func labeledField<Content: View>(
        _ label: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.appCaption).foregroundStyle(Color.cjTextSecondary).padding(.leading, 4)
            content()
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView(repository: MockAuthRepository())
    }
}
