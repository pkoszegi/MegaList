//
//  EditItemViewModel.swift
//  MegaList
//
//  Created by Petra Koszegi on 24/02/2026.
//

import Foundation

@Observable
@MainActor
final class EditItemViewModel {

    var item: MegaItem
    let fieldController: ItemFieldValuesController

    init(item: MegaItem) {
        self.item = item
        self.fieldController = ItemFieldValuesController(
            existingValues: item.fieldValues
        )
    }

    func persistChanges() {
        item.fieldValues = fieldController.allValues
    }
}
