//
//  ListCreationViewModel.swift
//  MegaList
//
//  Created by Petra Koszegi on 24/02/2026.
//

import Foundation
import SwiftData

@Observable
@MainActor
final class ListCreationViewModel{
    var title: String = ""
    var selectedTemplate: ListTemplate?

    var availableTemplates: [ListTemplate] {
        BuiltInTemplates.all
    }

    var canCreate: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func create(in context: ModelContext) {
        let list = MegaList(
            title: title,
            template: selectedTemplate
        )
        context.insert(list)
        title = ""
        selectedTemplate = nil
    }
}
