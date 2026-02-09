//
//  AddItemViewModel.swift
//  MegaList
//
//  Created by Petra Koszegi on 09/02/2026.
//

import Foundation
import SwiftData

@Observable
class AddItemViewModel{

    let list: MegaList

    var name: String = ""
    var selectedCategory: Category?
    var fieldValues: [UUID: ItemFieldValue] = [:]

    init(list: MegaList) {
        self.list = list
        initializeFieldValues()
    }

    private func initializeFieldValues() {
        guard let fields = list.template?.fields else { return }

        for field in fields {
            fieldValues[field.id] = ItemFieldValue(field: field)
        }
    }

    var canCreate: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func createItem(in context: ModelContext) {
        let item = MegaItem(
            name: name,
            isDone: false,
            category: selectedCategory
        )

        item.parentList = list
        item.fieldValues = Array(fieldValues.values)

        context.insert(item)
    }
}
