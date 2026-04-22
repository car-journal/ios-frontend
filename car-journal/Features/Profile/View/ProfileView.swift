//
//  ProfileView.swift
//  car-journal
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authManager: AuthManager
    let userRepository: UserRepositoryProtocol
    @StateObject private var viewModel: ProfileViewModel
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var isShowingEditProfile = false
    @State private var isShowingChangePassword = false

    init(authManager: AuthManager, userRepository: UserRepositoryProtocol) {
        self.authManager = authManager
        self.userRepository = userRepository
        _viewModel = StateObject(wrappedValue: ProfileViewModel(repository: userRepository))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.cjBackground.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        profileHeader
                        accountSection
                        appearanceSection
                        logoutSection
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.cjBackground, for: .navigationBar)
            .task { await viewModel.loadMe() }
            .sheet(isPresented: $isShowingEditProfile) {
                EditProfileView(viewModel: viewModel)
            }
            .sheet(isPresented: $isShowingChangePassword) {
                ChangePasswordView(viewModel: viewModel)
            }
        }
    }

    // MARK: - Profile header
    private var profileHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.cjPrimary.opacity(0.15))
                    .frame(width: 80, height: 80)
                if let urlStr = viewModel.user?.pictureUrl, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        anonymousIcon
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                } else {
                    anonymousIcon
                }
            }

            if let user = viewModel.user {
                Text("\(user.firstName) \(user.lastName ?? "")")
                    .font(.appTitle2)
                    .foregroundStyle(Color.cjTextPrimary)
                Text(user.email)
                    .font(.appSubheadline)
                    .foregroundStyle(Color.cjTextSecondary)
            } else if viewModel.isLoading {
                ProgressView().tint(Color.appShade2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private var anonymousIcon: some View {
        Image(systemName: "person.fill")
            .font(.system(size: 36))
            .foregroundStyle(Color.cjPrimary)
    }

    // MARK: - Account section
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Account", icon: "person.circle.fill")
            VStack(spacing: 0) {
                profileRow(icon: "pencil", label: "Edit Profile", color: Color.appShade2) {
                    isShowingEditProfile = true
                }
                Divider().padding(.leading, 52).opacity(0.5)
                profileRow(icon: "lock.fill", label: "Change Password", color: Color.appShade1) {
                    isShowingChangePassword = true
                }
            }
            .appCard()
        }
    }

    // MARK: - Appearance section
    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Appearance", icon: "paintbrush.fill")
            VStack(spacing: 0) {
                ForEach(AppThemeMode.allCases, id: \.rawValue) { mode in
                    Button {
                        themeManager.set(mode)
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: mode.icon)
                                .font(.appSubheadline)
                                .foregroundStyle(themeManager.mode == mode ? Color.cjOnPrimary : Color.appShade2)
                                .frame(width: 32, height: 32)
                                .background(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(themeManager.mode == mode ? Color.cjPrimary : Color.appShade1.opacity(0.12))
                                )
                            Text(mode.label).font(.appBody).foregroundStyle(Color.cjTextPrimary)
                            Spacer()
                            if themeManager.mode == mode {
                                Image(systemName: "checkmark").font(.appSubheadline).fontWeight(.semibold).foregroundStyle(Color.cjPrimary)
                            }
                        }
                        .padding(.horizontal, 16).padding(.vertical, 12)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    if mode != AppThemeMode.allCases.last {
                        Divider().padding(.leading, 52).opacity(0.5)
                    }
                }
            }
            .appCard()
        }
    }

    // MARK: - Logout section
    private var logoutSection: some View {
        Button {
            authManager.logout()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Logout")
            }
            .font(.appSubheadline).fontWeight(.semibold).foregroundStyle(Color.appNegative)
            .frame(maxWidth: .infinity).padding(.vertical, 14)
            .background(Color.appNegative.opacity(0.10))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }

    // MARK: - Helpers
    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.appSubheadline).foregroundStyle(Color.appShade2)
            Text(title).font(.appHeadline).foregroundStyle(Color.cjTextPrimary)
        }.padding(.leading, 4)
    }

    private func profileRow(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.appSubheadline).foregroundStyle(Color.cjOnPrimary)
                    .frame(width: 32, height: 32)
                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(color))
                Text(label).font(.appBody).foregroundStyle(Color.cjTextPrimary)
                Spacer()
                Image(systemName: "chevron.right").font(.appCaption).foregroundStyle(Color.cjTextSecondary)
            }
            .padding(.horizontal, 16).padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Edit Profile Sheet
struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.cjBackground.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        AppField("First Name", text: $viewModel.profileForm.firstName).textInputAutocapitalization(.words)
                        AppField("Last Name (optional)", text: $viewModel.profileForm.lastName).textInputAutocapitalization(.words)

                        // Gender picker
                        Menu {
                            Button("Male") { viewModel.profileForm.gender = "male" }
                            Button("Female") { viewModel.profileForm.gender = "female" }
                            Button("Not specified") { viewModel.profileForm.gender = "" }
                        } label: {
                            HStack {
                                Text(viewModel.profileForm.gender.isEmpty ? "Gender (optional)" : viewModel.profileForm.gender.capitalized)
                                    .font(.appBody)
                                    .foregroundStyle(viewModel.profileForm.gender.isEmpty ? Color.cjTextSecondary : Color.cjTextPrimary)
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down").font(.appCaption).foregroundStyle(Color.cjTextSecondary)
                            }
                            .appInput()
                        }

                        AppField("Picture URL (optional)", text: $viewModel.profileForm.pictureUrl).textInputAutocapitalization(.none)

                        if let error = viewModel.errorMessageProfile {
                            Label(error, systemImage: "xmark.circle.fill")
                                .font(.appCaption).foregroundStyle(Color.appNegative)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        AppButton(title: "Save", isLoading: viewModel.isUpdatingProfile) {
                            await viewModel.updateProfile()
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.cjBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(Color.cjTextSecondary)
                }
            }
        }
        .onChange(of: viewModel.didUpdateProfileSuccessfully) { _, success in
            guard success else { return }
            dismiss()
        }
    }
}

// MARK: - Change Password Sheet
struct ChangePasswordView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.cjBackground.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        SecureField("Current Password", text: $viewModel.passwordForm.oldPassword)
                            .font(.appBody).foregroundStyle(Color.cjTextPrimary).appInput()
                        SecureField("New Password (6–25 chars)", text: $viewModel.passwordForm.newPassword)
                            .font(.appBody).foregroundStyle(Color.cjTextPrimary).appInput()
                        SecureField("Confirm New Password", text: $viewModel.passwordForm.confirmPassword)
                            .font(.appBody).foregroundStyle(Color.cjTextPrimary).appInput()

                        if let error = viewModel.errorMessagePassword {
                            Label(error, systemImage: "xmark.circle.fill")
                                .font(.appCaption).foregroundStyle(Color.appNegative)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        AppButton(title: "Update Password", isLoading: viewModel.isUpdatingPassword) {
                            await viewModel.updatePassword()
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.cjBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(Color.cjTextSecondary)
                }
            }
        }
        .onChange(of: viewModel.didUpdatePasswordSuccessfully) { _, success in
            guard success else { return }
            dismiss()
        }
    }
}

#Preview {
    ProfileView(authManager: AuthManager(), userRepository: MockUserRepository())
}
