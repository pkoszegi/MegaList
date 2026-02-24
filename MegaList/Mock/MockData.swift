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
    static let sampleCategories = [Category.fruits, .dairy, .cleaning, .bakery, .drinks]
    static let sampleList = MegaList(title: "Groceries", items: MegaItem.samples)
    
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
        
        sampleCategories.forEach { context.insert($0) }

        let groceries = MegaList(title: "Groceries")
        context.insert(groceries)
        
        MegaItem.samples.forEach { sample in
            let item = MegaItem(name: sample.name, category: sample.category)
            groceries.items.append(item)
            context.insert(item)
        }
        
        context.insert(MegaList(title: "Chores", template: .chores))
        context.insert(MegaList(title: "Party Supplies"))
        context.insert(MegaList(title: "Packing List", template: .packingList))
        
        return container
    }
}
