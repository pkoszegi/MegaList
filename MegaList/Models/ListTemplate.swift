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
