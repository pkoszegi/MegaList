//
//  CustomEmojiInputView.swift
//  MegaList
//
//  Created by Petra Koszegi on 20/02/2026.
//

import SwiftUI

struct CustomEmojiInputView: View {
    @Environment(\.dismiss) private var dismiss

    let usedEmojis: Set<String>
    var onSelect: (String) -> Void

    @State private var input = ""

    var isValid: Bool {
        input.isSingleEmoji &&
        !usedEmojis.contains(input)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                TextField("Enter emoji", text: $input)
                    .multilineTextAlignment(.center)

                Button("Use Emoji") {
                    if isValid {
                        onSelect(input)
                        dismiss()
                    }
                }
                .disabled(!isValid)
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Custom Emoji")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension String {
    var isSingleEmoji: Bool {
        guard count == 1 else { return false }
        return unicodeScalars.first?.properties.isEmojiPresentation == true
    }
}

