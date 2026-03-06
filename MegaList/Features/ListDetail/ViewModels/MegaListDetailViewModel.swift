//
//  MegaListDetailViewModel.swift
//  MegaList
//
//  Created by Petra Koszegi on 24/11/2025.
//

import SwiftData
import SwiftUI

@Observable
final class MegaListDetailViewModel {
    func sortedItems(from items: [MegaItem]) -> [MegaItem] {
        items.sorted { lhs, rhs in
            let lhsCategoryName = lhs.category?.name ?? "zzz"
            let rhsCategoryName = rhs.category?.name ?? "zzz"
            
            if lhsCategoryName != rhsCategoryName {
                return lhsCategoryName < rhsCategoryName
            }
            
            return lhs.name < rhs.name
        }
    }

    
    func activeItems(from items: [MegaItem]) -> [MegaItem] {
        sortedItems(from: items).filter { !$0.isDone }
    }

    func completedItems(from items: [MegaItem]) -> [MegaItem] {
        sortedItems(from: items).filter { $0.isDone }
    }

    func usedCategories(from items: [MegaItem]) -> [Category] {
        let categories = items.compactMap { $0.category }
        return Array(Set(categories))
            .sorted { $0.name < $1.name }
    }
}
