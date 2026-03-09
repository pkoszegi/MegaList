//
//  ItemFieldValue.swift
//  MegaList
//
//  Created by Petra Koszegi on 12/12/2025.
//

import Foundation
import SwiftData

@Model
class ItemFieldValue {
    @Attribute(.unique) var id: UUID
    
    var fieldId: UUID
    var fieldName: String
    var type: FieldType
    var sortOrder: Int
    
    var boolValue: Bool?
    var dateValue: Date?
    var textValue: String?
    var numberValue: Double?
    
    init(field: TemplateField) {
        self.id = UUID()
        self.fieldId = field.id
        self.fieldName = field.name
        self.type = field.type
        self.sortOrder = field.sortOrder
    }
    
    private static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    var displayStringIfValuePresent: String? {
        var value: String? = nil

        switch type {
        case .boolean:
            if let boolValue {
                value = boolValue ? String(localized: "Yes") : String(localized: "No")
            }
        case .date:
            if let date = dateValue {
                value = Self.shortDateFormatter.string(from: date)
            }
        case .text:
            if let textValue, !textValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                value = textValue
            }
        case .number:
            if let numberValue {
                value = String(numberValue)
            }
        }

        guard let value else { return nil }
        return fieldName + ": " + value
    }

    var displayString: String {
        displayStringIfValuePresent ?? fieldName
    }
}
