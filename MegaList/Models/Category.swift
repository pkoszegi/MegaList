//
//  Category.swift
//  MegaList
//
//  Created by Petra Koszegi on 17/11/2025.
//

import Foundation
import SwiftData

@Model
class Category {
    @Attribute(.unique) var id = UUID()
    var name: String
    var emoji: String
    
    init(name: String, emoji: String) {
        self.name = name
        self.emoji = emoji
    }
}
