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
    
    // One value per template field
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

    // MARK: - Bindings

    func textBinding(for field: TemplateField) -> Binding<String> {
        Binding(
            get: {
                self.fieldValues[field.id]?.textValue ?? ""
            },
            set: {
                self.fieldValues[field.id]?.textValue = $0
            }
        )
    }

    func boolBinding(for field: TemplateField) -> Binding<Bool> {
        Binding(
            get: {
                self.fieldValues[field.id]?.boolValue ?? false
            },
            set: {
                self.fieldValues[field.id]?.boolValue = $0
            }
        )
    }

    func dateBinding(for field: TemplateField) -> Binding<Date> {
        Binding(
            get: {
                self.fieldValues[field.id]?.dateValue ?? Date()
            },
            set: {
                self.fieldValues[field.id]?.dateValue = $0
            }
        )
    }

    func numberBinding(for field: TemplateField) -> Binding<Double> {
        Binding(
            get: {
                self.fieldValues[field.id]?.numberValue ?? 0
            },
            set: {
                self.fieldValues[field.id]?.numberValue = $0
            }
        )
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
