//
//  EmojiPickerView.swift
//  MegaList
//
//  Created by Petra Koszegi on 13/02/2026.
//

import SwiftUI

struct EmojiPickerView: View {
    @Binding var selectedEmoji: String

    private let columns = [
        GridItem(.adaptive(minimum: 44))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(EmojiRepository.defaults, id: \.self) { emoji in
                    Text(emoji)
                        .font(.largeTitle)
                        .frame(width: 44, height: 44)
                        .background(
                            selectedEmoji == emoji
                                ? Color.accentColor.opacity(0.2)
                                : Color.clear
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onTapGesture {
                            selectedEmoji = emoji
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    EmojiPickerView(selectedEmoji: .constant(""))
}
