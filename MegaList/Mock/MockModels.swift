//
//  MockModels.swift
//  MegaList
//
//  Created by Petra Koszegi on 21/11/2025.
//

import Foundation

extension Category {
    static let fruits = Category(name: "Fruits", emoji: "🍎")
    static let dairy = Category(name: "Dairy", emoji: "🥛")
    static let cleaning = Category(name: "Cleaning", emoji: "🧽")
    static let bakery = Category(name: "Bakery", emoji: "🥐")
    static let drinks = Category(name: "Drinks", emoji: "🧃")
    static let clothes = Category(name: "Clothes", emoji: "👖")
    static let electronics = Category(name: "Electronics", emoji: "💻")
}

extension MegaItem {
    static func sample(
        name: String,
        category: Category,
        fieldValues: [ItemFieldValue] = []
    ) -> MegaItem {
        MegaItem(name: name, category: category)
    }
    
    static var samples: [MegaItem] = [
        .sample(name: "Apples", category: .fruits),
        .sample(name: "Bananas", category: .fruits),
        .sample(name: "Strawberries", category: .fruits),

        .sample(name: "Milk", category: .dairy),
        .sample(name: "Cheese", category: .dairy),
        .sample(name: "Yogurt", category: .dairy),

        .sample(name: "Baguette", category: .bakery),
        .sample(name: "Croissant", category: .bakery),

        .sample(name: "Dish Soap", category: .cleaning),
        .sample(name: "Bleach", category: .cleaning),

        .sample(name: "Orange Juice", category: .drinks),
        .sample(name: "Cola", category: .drinks)
    ]
}

