//
//  ProfileSetupView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI
import PhotosUI

struct ProfileSetupView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var name: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Text("Complete Your Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 40)

                    // Profile Photo
                    VStack(spacing: 15) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.accentColor, lineWidth: 3)
                                )
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                        }

                        PhotosPicker(selection: $selectedPhoto,
                                   matching: .images,
                                   photoLibrary: .shared()) {
                            Text(selectedImage == nil ? "Add Photo" : "Change Photo")
                                .font(.subheadline)
                                .foregroundColor(.accentColor)
                        }
                        .onChange(of: selectedPhoto) { newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    selectedImage = image
                                }
                            }
                        }

                        Text("Optional")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    // Name Field
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Display Name")
                            .font(.headline)

                        TextField("Enter your name", text: $name)
                            .textContentType(.name)
                            .autocapitalization(.words)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)

                        Text("This is how your name will appear to other users")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)

                    Spacer()

                    // Complete Button
                    VStack(spacing: 15) {
                        Button(action: completeSetup) {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Complete Setup")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .disabled(authViewModel.isLoading)

                        Button("Skip for Now") {
                            dismiss()
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }

                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func completeSetup() {
        Task {
            let displayName = name.isEmpty ? nil : name
            await authViewModel.completeProfileSetup(name: displayName, photo: selectedImage)
            if authViewModel.errorMessage == nil {
                dismiss()
            }
        }
    }
}

#Preview {
    ProfileSetupView()
        .environmentObject(AuthViewModel())
}
