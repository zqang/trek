//
//  AppleSignInButton.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI
import AuthenticationServices

struct AppleSignInButton: View {
    let action: () -> Void

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "apple.logo")
                    .font(.headline)

                Text("Continue with Apple")
                    .font(.headline)
            }
            .foregroundColor(colorScheme == .dark ? .black : .white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(colorScheme == .dark ? .white : .black)
            .cornerRadius(12)
        }
    }
}

#Preview {
    VStack {
        AppleSignInButton(action: {})
            .preferredColorScheme(.light)

        AppleSignInButton(action: {})
            .preferredColorScheme(.dark)
    }
    .padding()
}
