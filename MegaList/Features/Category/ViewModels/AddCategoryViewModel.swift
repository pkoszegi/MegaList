//
//  AddCategoryViewModel.swift
//  MegaList
//
//  Created by Petra Koszegi on 24/02/2026.
//

import Foundation

@Observable
@MainActor
final class AddCategoryViewModel {
    let usedEmojis: Set<String>

    var name: String = ""
    var emoji: String = ""
    var showingCustomEmojiInput = false

    init(usedEmojis: Set<String>) {
        self.usedEmojis = usedEmojis
    }

    var availableEmojis: [String] {
        EmojiRepository.defaults.filter { !usedEmojis.contains($0) }
    }

    var canCreate: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !emoji.isEmpty
    }

    func applyCustomEmoji(_ value: String) {
        emoji = value
    }

    func buildCategory() -> Category {
        Category(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            emoji: emoji
        )
    }
}
