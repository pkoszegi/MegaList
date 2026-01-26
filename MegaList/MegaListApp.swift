//
//  MegaListApp.swift
//  MegaList
//
//  Created by Petra Koszegi on 14/11/2025.
//
import SwiftData
import SwiftUI

@main
struct MegaListApp: App {
    let container: ModelContainer
    
    init() {
        if CommandLine.arguments.contains("--use-mock-data") {
            container = MockData.containerWithSampleData()
        } else {
            container = try! ModelContainer(for: MegaList.self, Category.self, MegaItem.self)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MegaListHomeView()
        }
        .modelContainer(container)
    }
}
