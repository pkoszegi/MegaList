//
//  TemplatePickerView.swift
//  MegaList
//
//  Created by Petra Koszegi on 06/03/2026.
//

import SwiftUI
import SwiftData

struct TemplatePickerView: View {
    @Query(sort: \ListTemplate.name) private var customTemplates: [ListTemplate]

    let availableTemplates: ([ListTemplate]) -> [ListTemplate]
    @Binding var selectedTemplate: ListTemplate?
    var onCreateTemplate: (ListTemplate) -> Void = { _ in }

    private var templates: [ListTemplate] {
        availableTemplates(customTemplates)
    }

    var body: some View {
        List {

            Button {
                selectedTemplate = nil
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("None")
                            .font(.headline)

                        Text("No extra fields")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    if selectedTemplate == nil {
                        Image(systemName: "checkmark")
                    }
                }
                .padding(.vertical, 6)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            ForEach(templates) { template in
                Button {
                    selectedTemplate = template
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {

                            Text(template.name)
                                .font(.headline)

                            if !template.orderedFields.isEmpty {
                                Text(template.orderedFields
                                    .map(\.name)
                                    .joined(separator: " • "))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()

                        if selectedTemplate?.id == template.id {
                            Image(systemName: "checkmark")
                        }
                    }
                    .padding(.vertical, 6)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Choose Template")
        
        .toolbar {
            NavigationLink {
                CreateTemplateView { createdTemplate in
                    selectedTemplate = createdTemplate
                    onCreateTemplate(createdTemplate)
                }
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

#Preview {
    let container = MockData.containerWithSampleData()
    return TemplatePickerPreviewHost()
        .modelContainer(container)
}

private struct TemplatePickerPreviewHost: View {
    @State private var selectedTemplate: ListTemplate?

    var body: some View {
        NavigationStack {
            TemplatePickerView(
                availableTemplates: { customTemplates in
                    ListCreationViewModel().availableTemplates(customTemplates: customTemplates)
                },
                selectedTemplate: $selectedTemplate
            )
        }
    }
}
