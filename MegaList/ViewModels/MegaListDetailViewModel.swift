//
//  MegaListDetailViewModel.swift
//  MegaList
//
//  Created by Petra Koszegi on 24/11/2025.
//

import SwiftData
import SwiftUI

@Observable
class MegaListDetailViewModel {
    var list: MegaList
    
    init(list: MegaList) {
        self.list = list
    }
    
    var sortedItems: [MegaItem] {
        Array(list.items).sorted { lhs, rhs in
            let lhsCategoryName = lhs.category?.name ?? "zzz"
            let rhsCategoryName = rhs.category?.name ?? "zzz"
            
            if lhsCategoryName != rhsCategoryName {
                return lhsCategoryName < rhsCategoryName
            }
            
            if lhs.isDone != rhs.isDone {
                return !lhs.isDone && rhs.isDone
            }
            
            return lhs.name < rhs.name
        }
    }
}
