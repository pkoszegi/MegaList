//
//  MegaList.swift
//  MegaList
//
//  Created by Petra Koszegi on 14/11/2025.
//
import Foundation
import SwiftData

@Model
class MegaList {
    @Attribute(.unique) var id: UUID
    var title: String
//    var template: ListTemplate
    @Relationship(deleteRule: .cascade) var items: [MegaItem]
    
    init(title: String) {
        self.id = UUID()
        self.title = title
        self.items = []
    }
    
    init(title: String, items: [MegaItem]) {
        self.id = UUID()
        self.title = title
        self.items = items
    }
    
}
