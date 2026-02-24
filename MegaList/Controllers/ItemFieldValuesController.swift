//
//  ItemFieldValuesController.swift
//  MegaList
//
//  Created by Petra Koszegi on 24/02/2026.
//

import SwiftUI
import SwiftData

@Observable
@MainActor
final class ItemFieldValuesController {

    private(set) var values: [UUID: ItemFieldValue] = [:]

    init(template: ListTemplate?) {
        guard let fields = template?.fields else { return }

        for field in fields {
            values[field.id] = ItemFieldValue(field: field)
        }
    }

    init(existingValues: [ItemFieldValue]) {
        for value in existingValues {
            values[value.fieldID] = value
        }
    }

    var allValues: [ItemFieldValue] {
        Array(values.values)
    }

    // MARK: - Bindings

    func textBinding(for field: TemplateField) -> Binding<String> {
        Binding(
            get: { self.values[field.id]?.textValue ?? "" },
            set: { self.values[field.id]?.textValue = $0 }
        )
    }

    func boolBinding(for field: TemplateField) -> Binding<Bool> {
        Binding(
            get: { self.values[field.id]?.boolValue ?? false },
            set: { self.values[field.id]?.boolValue = $0 }
        )
    }

    func dateBinding(for field: TemplateField) -> Binding<Date> {
        Binding(
            get: { self.values[field.id]?.dateValue ?? Date() },
            set: { self.values[field.id]?.dateValue = $0 }
        )
    }

    func numberBinding(for field: TemplateField) -> Binding<Double> {
        Binding(
            get: { self.values[field.id]?.numberValue ?? 0 },
            set: { self.values[field.id]?.numberValue = $0 }
        )
    }
}
