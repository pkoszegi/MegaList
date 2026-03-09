//
//  CreateTemplateViewModel.swift
//  MegaList
//
//  Created by Petra Koszegi on 24/02/2026.
//

import SwiftUI
import SwiftData

struct TemplateFieldDraft: Identifiable {
    let id: UUID = UUID()
    var name: String = ""
    var type: FieldType = .text
}

@Observable
@MainActor
final class CreateTemplateViewModel {
    let maxFieldCount = 3

    var templateName: String = ""
    var fields: [TemplateFieldDraft] = [TemplateFieldDraft()]
    private(set) var existingTemplateNames: Set<String> = BuiltInTemplates.names

    var canAddField: Bool {
        fields.count < maxFieldCount &&
        fields.allSatisfy(isValidField)
    }

    var hasDuplicateTemplateName: Bool {
        let normalizedName = normalize(templateName)
        guard !normalizedName.isEmpty else { return false }
        return existingTemplateNames.contains(normalizedName)
    }

    var canCreate: Bool {
        let trimmedName = normalize(templateName)
        guard !trimmedName.isEmpty else { return false }
        guard !hasDuplicateTemplateName else { return false }

        let normalizedFieldNames = fields
            .map { normalize($0.name) }
            .filter { !$0.isEmpty }

        guard normalizedFieldNames.count == fields.count else { return false }

        return Set(normalizedFieldNames).count == normalizedFieldNames.count
    }

    func updateExistingTemplateNames(using customTemplates: [ListTemplate]) {
        let customNames = customTemplates.map { normalize($0.name) }
        existingTemplateNames = Set(customNames).union(BuiltInTemplates.names)
    }

    func addField() {
        guard canAddField else { return }
        fields.append(TemplateFieldDraft())
    }

    func removeField(at offsets: IndexSet) {
        let safeOffsets = IndexSet(offsets.filter { $0 < fields.count })
        guard !safeOffsets.isEmpty else { return }

        fields.remove(atOffsets: safeOffsets)
        if fields.isEmpty {
            fields = [TemplateFieldDraft()]
        }
    }

    func create(in context: ModelContext) -> ListTemplate {
        let createdTemplate = ListTemplate(
            name: templateName.trimmingCharacters(in: .whitespacesAndNewlines),
            fields: fields.enumerated().map { index, draft in
                TemplateField(
                    name: draft.name.trimmingCharacters(in: .whitespacesAndNewlines),
                    type: draft.type,
                    sortOrder: index
                )
            }
        )

        context.insert(createdTemplate)
        return createdTemplate
    }

    private func isValidField(_ field: TemplateFieldDraft) -> Bool {
        let trimmedName = field.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return false }

        switch field.type {
        case .text, .number, .date, .boolean:
            return true
        }
    }

    private func normalize(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}
