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
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func addItem(in context: ModelContext) {
        let item = MegaItem(
            name: name,
            isDone: false,
            category: selectedCategory
        )

        item.parentList = list
        if !list.items.contains(where: { $0.id == item.id }) {
            list.items.append(item)
        }
        item.fieldValues = fieldController.allValues
        
        context.insert(item)
        try? context.save()
    }
}
