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
    let fieldController: ItemFieldsState

    init(item: MegaItem) {
        self.item = item
        self.fieldController = ItemFieldsState(
            existingValues: item.fieldValues
        )
    }

    func persistChanges() {
        item.fieldValues = fieldController.allValues
    }
}
