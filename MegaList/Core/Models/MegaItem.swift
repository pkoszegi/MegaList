//
//  MegaItem.swift
//  MegaList
//
//  Created by Petra Koszegi on 14/11/2025.
//
import Foundation
import SwiftData

@Model
class MegaItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var isDone: Bool
    var category: Category?
    
    @Relationship(deleteRule: .cascade)
    var fieldValues: [ItemFieldValue] = []
    
    @Relationship var parentList: MegaList?
    
    init(name: String, isDone: Bool = false, category: Category? = nil) {
        self.id = UUID()
        self.name = name
        self.isDone = isDone
        self.category = category
    }
}
