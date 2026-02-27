//
//  File.swift
//  MegaList
//
//  Created by Petra Koszegi on 21/11/2025.
//

import Foundation
import SwiftData

@MainActor
struct MockData {
    static func sampleCategories() -> [Category] {
        [Category.fruits, .dairy, .cleaning, .bakery, .drinks]
    }

    static func sampleList() -> MegaList {
        MegaList(title: "Groceries", items: MegaItem.samples)
    }
    
    static func makeContainer() -> ModelContainer {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            return try ModelContainer(
                for: MegaList.self,
                Category.self,
                MegaItem.self,
                ListTemplate.self,
                TemplateField.self,
                ItemFieldValue.self,
                configurations: config
            )
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }
    
    static func containerWithSampleData() -> ModelContainer {
        let container = makeContainer()
        let context = container.mainContext

        let categories = sampleCategories()
        categories.forEach { context.insert($0) }

        let categoriesByName = Dictionary(
            uniqueKeysWithValues: categories.map { ($0.name, $0) }
        )

        let groceries = MegaList(title: "Groceries")
        context.insert(groceries)

        let sampleItems: [(name: String, categoryName: String)] = [
            ("Apples", "Fruits"),
            ("Bananas", "Fruits"),
            ("Strawberries", "Fruits"),
            ("Milk", "Dairy"),
            ("Cheese", "Dairy"),
            ("Yogurt", "Dairy"),
            ("Baguette", "Bakery"),
            ("Croissant", "Bakery"),
            ("Dish Soap", "Cleaning"),
            ("Bleach", "Cleaning"),
            ("Orange Juice", "Drinks"),
            ("Cola", "Drinks")
        ]

        for sample in sampleItems {
            let item = MegaItem(
                name: sample.name,
                category: categoriesByName[sample.categoryName]
            )
            groceries.items.append(item)
            context.insert(item)
        }

        context.insert(MegaList(title: "Chores", template: .chores))
        context.insert(MegaList(title: "Party Supplies"))
        context.insert(MegaList(title: "Packing List", template: .packingList))

        return container
    }
}
