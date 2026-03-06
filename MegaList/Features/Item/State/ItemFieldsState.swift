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
final class ItemFieldsState {

    private(set) var values: [UUID: ItemFieldValue] = [:]
    private var numberDrafts: [UUID: String] = [:]

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

    func numberTextBinding(for field: TemplateField) -> Binding<String> {
        Binding(
            get: {
                if let draft = self.numberDrafts[field.id] {
                    return draft
                }

                guard let number = self.values[field.id]?.numberValue else {
                    return ""
                }

                return String(number)
            },
            set: { newValue in
                let sanitized = Self.sanitizeNumberInput(newValue)
                let trimmed = sanitized.trimmingCharacters(in: .whitespacesAndNewlines)

                guard !trimmed.isEmpty else {
                    self.numberDrafts[field.id] = ""
                    self.values[field.id]?.numberValue = nil
                    return
                }

                if let parsed = Self.parseNumber(from: trimmed) {
                    self.numberDrafts[field.id] = sanitized
                    self.values[field.id]?.numberValue = parsed
                }
            }
        )
    }

    private static func parseNumber(from value: String) -> Double? {
        Double(value.replacingOccurrences(of: ",", with: "."))
    }

    private static func sanitizeNumberInput(_ raw: String) -> String {
        var result = ""
        var hasSeparator = false

        for character in raw {
            if character.isNumber {
                result.append(character)
                continue
            }

            if (character == "." || character == ",") && !hasSeparator {
                hasSeparator = true
                if result.isEmpty {
                    result.append("0")
                }
                result.append(character)
            }
        }

        return result
    }
}
