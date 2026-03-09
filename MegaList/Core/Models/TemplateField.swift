//
//  TemplateField.swift
//  MegaList
//
//  Created by Petra Koszegi on 12/12/2025.
//

import Foundation
import SwiftData

enum FieldType: String, Codable {
    case boolean
    case date
    case text
    case number
}

@Model
class TemplateField: Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    var name: String
    var type: FieldType
    var sortOrder: Int
    
    init(name: String, type: FieldType, sortOrder: Int = 0) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.sortOrder = sortOrder
    }
}
