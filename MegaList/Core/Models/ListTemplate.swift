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
        self.fields = fields.enumerated().map { index, field in
            field.sortOrder = index
            return field
        }
    }
}

extension ListTemplate {
    var orderedFields: [TemplateField] {
        fields.sorted {
            if $0.sortOrder != $1.sortOrder {
                return $0.sortOrder < $1.sortOrder
            }
            return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }
}

extension ListTemplate {
    static var groceries: ListTemplate {
        .init(
            name: "Groceries",
            fields: [
                TemplateField(name: "quantity", type: .number),
                TemplateField(name: "unit", type: .text),
                TemplateField(name: "aisle", type: .number)
            ]
        )
    }

    static var chores: ListTemplate {
        .init(
            name: "Chores",
            fields: [
                TemplateField(name: "room", type: .text),
                TemplateField(name: "deadline", type: .date)
            ]
        )
    }

    static var packingList: ListTemplate {
        .init(
            name: "Packing List",
            fields: [
                TemplateField(name: "quantity", type: .number),
                TemplateField(name: "bag", type: .text)
            ]
        )
    }

    static var projects: ListTemplate {
        .init(
            name: "Projects",
            fields: [
                TemplateField(name: "started", type: .date),
                TemplateField(name: "deadline", type: .date),
                TemplateField(name: "priority", type: .number)
            ]
        )
    }
}

enum BuiltInTemplates {
    static var all: [ListTemplate] {
        [
            .groceries,
            .chores,
            .packingList,
            .projects
        ]
    }

    static let names: Set<String> = [
        "groceries",
        "chores",
        "packing list",
        "projects"
    ]
}
