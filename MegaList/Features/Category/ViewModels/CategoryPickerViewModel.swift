//
//  CategoryPickerViewModel.swift
//  MegaList
//
//  Created by Petra Koszegi on 24/02/2026.
//

import Foundation

@Observable
@MainActor
final class CategoryPickerViewModel {
    let usedCategories: [Category]
    let allCategories: [Category]

    var showAddSheet = false

    init(usedCategories: [Category], allCategories: [Category]) {
        self.usedCategories = usedCategories
        self.allCategories = allCategories
    }

    var unusedCategories: [Category] {
        allCategories.filter { !usedCategories.contains($0) }
    }

    var usedEmojis: Set<String> {
        Set(usedCategories.compactMap { $0.emoji })
    }

    func isDuplicate(_ category: Category) -> Bool {
        allCategories.contains(where: {
            $0.name.lowercased() == category.name.lowercased() ||
            $0.emoji == category.emoji
        })
    }
}
