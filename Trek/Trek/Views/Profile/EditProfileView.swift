//
//  EditProfileView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showingImagePicker = false

    var body: some View {
        NavigationView {
            Form {
                // Profile Photo Section
                Section {
                    HStack {
                        Spacer()

                        VStack(spacing: 15) {
                            // Profile Image
                            if let selectedImage = viewModel.selectedProfileImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else if let photoURL = viewModel.user?.photoURL,
                                      let url = URL(string: photoURL) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray)
                                    .frame(width: 100, height: 100)
                            }

                            // Change Photo Button
                            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                Text("Change Photo")
                                    .font(.subheadline)
                                    .foregroundColor(.accentColor)
                            }
                            .onChange(of: selectedPhotoItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        viewModel.selectedProfileImage = uiImage
                                    }
                                }
                            }
                        }

                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)

                // Display Name Section
                Section(header: Text("Display Name")) {
                    TextField("Your name", text: $viewModel.editedDisplayName)
                }

                // Bio Section
                Section(header: Text("Bio")) {
                    TextEditor(text: $viewModel.editedBio)
                        .frame(minHeight: 100)
                }
                .listRowSeparator(.hidden)

                // Email (Read-only)
                Section(header: Text("Email")) {
                    Text(viewModel.user?.email ?? "")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            let success = await viewModel.updateProfile()
                            if success {
                                dismiss()
                            }
                        }
                    }
                    .disabled(viewModel.isSaving)
                }
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
        }
    }
}

#Preview {
    EditProfileView(viewModel: {
        let vm = ProfileViewModel(userId: "test")
        vm.user = User(
            id: "test",
            email: "test@example.com",
            displayName: "John Doe",
            photoURL: nil,
            bio: "Love running!",
            createdAt: Date()
        )
        vm.editedDisplayName = "John Doe"
        vm.editedBio = "Love running!"
        return vm
    }())
}
