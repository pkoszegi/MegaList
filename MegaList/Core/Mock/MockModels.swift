//
//  MockModels.swift
//  MegaList
//
//  Created by Petra Koszegi on 21/11/2025.
//

import Foundation

extension Category {
    static var fruits: Category { Category(name: "Fruits", emoji: "🍎") }
    static var dairy: Category { Category(name: "Dairy", emoji: "🥛") }
    static var cleaning: Category { Category(name: "Cleaning", emoji: "🧽") }
    static var bakery: Category { Category(name: "Bakery", emoji: "🥐") }
    static var drinks: Category { Category(name: "Drinks", emoji: "🧃") }
    static var clothes: Category { Category(name: "Clothes", emoji: "👖") }
    static var electronics: Category { Category(name: "Electronics", emoji: "💻") }
}

extension MegaItem {
    static func sample(name: String, category: Category) -> MegaItem {
        MegaItem(name: name, category: category)
    }
    
    static var samples: [MegaItem] {
        let fruits = Category.fruits
        let dairy = Category.dairy
        let bakery = Category.bakery
        let cleaning = Category.cleaning
        let drinks = Category.drinks

        return [
            .sample(name: "Apples", category: fruits),
            .sample(name: "Bananas", category: fruits),
            .sample(name: "Strawberries", category: fruits),

            .sample(name: "Milk", category: dairy),
            .sample(name: "Cheese", category: dairy),
            .sample(name: "Yogurt", category: dairy),

            .sample(name: "Baguette", category: bakery),
            .sample(name: "Croissant", category: bakery),

            .sample(name: "Dish Soap", category: cleaning),
            .sample(name: "Bleach", category: cleaning),

            .sample(name: "Orange Juice", category: drinks),
            .sample(name: "Cola", category: drinks)
        ]
    }
}
