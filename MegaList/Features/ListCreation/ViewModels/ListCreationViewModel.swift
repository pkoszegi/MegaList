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
    private let builtInTemplates: [ListTemplate]

    var title: String = ""
    var selectedTemplate: ListTemplate?
    var showingCreateTemplate = false

    init() {
        self.builtInTemplates = BuiltInTemplates.all
    }

    init(builtInTemplates: [ListTemplate]) {
        self.builtInTemplates = builtInTemplates
    }

    func availableTemplates(customTemplates: [ListTemplate]) -> [ListTemplate] {
        var seenNames = Set<String>()
        var result: [ListTemplate] = []

        for template in builtInTemplates + customTemplates {
            let normalizedName = template.name
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()

            guard seenNames.insert(normalizedName).inserted else {
                continue
            }

            result.append(template)
        }

        return result
    }

    var canCreate: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func create(in context: ModelContext) -> MegaList {
        let list = MegaList(
            title: title,
            template: selectedTemplate
        )
        context.insert(list)
        reset()
        return list
    }

    func didCreateTemplate(_ template: ListTemplate) {
        selectedTemplate = template
        showingCreateTemplate = false
    }

    func reset() {
        title = ""
        selectedTemplate = nil
        showingCreateTemplate = false
    }
}
