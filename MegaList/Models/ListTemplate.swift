//
//  ListTemplate.swift
//  MegaList
//
//  Created by Petra Koszegi on 12/12/2025.
//

import Foundation
import SwiftData

@Model
class ListTemplate {
    @Attribute(.unique) var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade)
    var fields: [TemplateField] = []
    
    init(name: String, fields: [TemplateField]) {
        self.id = UUID()
        self.name = name
        self.fields = fields
    }
}

extension ListTemplate {
    static let groceries: ListTemplate = .init(name: "Groceries", fields: [TemplateField(name: "quantity", type: .number), TemplateField(name: "unit", type: .text), TemplateField(name: "aisle", type: .number)])
    static let chores: ListTemplate = .init(name: "Chores", fields: [TemplateField(name: "room", type: .text), TemplateField(name: "deadline", type: .date)])
    static let packingList: ListTemplate = .init(name: "Packing List", fields: [TemplateField(name: "quantity", type: .number), TemplateField(name: "bag", type: .text)])
    static let projects: ListTemplate = .init(name: "Projects", fields: [TemplateField(name: "started", type: .date), TemplateField(name: "deadline", type: .date), TemplateField(name: "priority", type: .number)])
}
