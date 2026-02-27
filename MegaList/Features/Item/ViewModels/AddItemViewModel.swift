//
//  AddItemViewModel.swift
//  MegaList
//
//  Created by Petra Koszegi on 09/02/2026.
//

import SwiftUI
import SwiftData

@Observable
@MainActor
final class AddItemViewModel {

    let list: MegaList

    var name: String = ""
    var selectedCategory: Category?

    var usedCategories: [Category] {
        let categoriesInList = list.items.compactMap { $0.category }
        return Array(Set(categoriesInList))
    }
    
    let fieldController: ItemFieldsState

    init(list: MegaList) {
        self.list = list
        self.fieldController = ItemFieldsState(template: list.template)
    }

    var canCreate: Bool {
        Self.canCreate(name: name)
    }

    static func canCreate(name: String) -> Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func createItem(in context: ModelContext) {
        let item = MegaItem(
            name: name,
            isDone: false,
            category: selectedCategory
        )

        item.parentList = list
        item.fieldValues = fieldController.allValues
        
        context.insert(item)
    }
}
