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
                for: MegaList.self, Category.self, MegaItem.self,
                configurations: config
            )
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }
    
    static func containerWithSampleData() -> ModelContainer {
        let container = makeContainer()
        let context = container.mainContext
        
        let groceries = MegaList(title: "Groceries")
        groceries.items.append(contentsOf: MegaItem.samples)
        context.insert(groceries)
        context.insert(MegaList(title: "Chores"))
        context.insert(MegaList(title: "Party Supplies"))
        context.insert(MegaList(title: "Packing List"))
        
        return container
    }
}

