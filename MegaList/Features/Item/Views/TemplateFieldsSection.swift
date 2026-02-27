//
//  TemplateFieldsSection.swift
//  MegaList
//
//  Created by Petra Koszegi on 24/02/2026.
//

import SwiftUI

struct TemplateFieldsSection: View {
    let template: ListTemplate
    let controller: ItemFieldsState

    var body: some View {
        Section("Details") {
            ForEach(Array(template.fields), id: \.id) { field in
                fieldView(for: field)
            }
        }
    }

    @ViewBuilder
    private func fieldView(for field: TemplateField) -> some View {
        switch field.type {

        case .text:
            LabeledContent(field.name) {
                TextField("Value", text: controller.textBinding(for: field))
                    .multilineTextAlignment(.trailing)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

        case .boolean:
            Toggle(
                field.name,
                isOn: controller.boolBinding(for: field)
            )

        case .date:
            DatePicker(
                field.name,
                selection: controller.dateBinding(for: field),
                displayedComponents: .date
            )

        case .number:
            LabeledContent(field.name) {
                TextField(
                    "0",
                    value: controller.numberBinding(for: field),
                    format: .number
                )
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
            }
        }
    }
}

#Preview {
    let template = ListTemplate.chores
    let controller = ItemFieldsState(template: template)

    Form {
        TemplateFieldsSection(
            template: template,
            controller: controller
        )
    }
}
