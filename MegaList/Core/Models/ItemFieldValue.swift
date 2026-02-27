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
    
    var fieldID: UUID
    var fieldName: String
    var type: FieldType
    
    var boolValue: Bool?
    var dateValue: Date?
    var textValue: String?
    var numberValue: Double?
    
    init(field: TemplateField) {
        self.id = UUID()
        self.fieldID = field.id
        self.fieldName = field.name
        self.type = field.type
    }
}
