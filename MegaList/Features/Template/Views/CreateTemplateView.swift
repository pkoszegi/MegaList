//
//  CreateTemplateView.swift
//  MegaList
//
//  Created by Petra Koszegi on 24/02/2026.
//

import SwiftData
import SwiftUI

struct CreateTemplateView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query(sort: \ListTemplate.name) private var existingTemplates: [ListTemplate]

    @State private var viewModel = CreateTemplateViewModel()

    var onCreate: (ListTemplate) -> Void

    private var fieldTypeOptions: [FieldType] {
        [.text, .number, .date, .boolean]
    }

    private var existingTemplateNames: Set<String> {
        Set(
            existingTemplates.map {
                $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            }
        )
        .union(BuiltInTemplates.names)
    }

    private var canCreate: Bool {
        viewModel.canCreate(existingTemplateNames: existingTemplateNames)
    }

    private var hasDuplicateTemplateName: Bool {
        viewModel.hasDuplicateTemplateName(in: existingTemplateNames)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Template") {
                    TextField("Template name", text: $viewModel.templateName)
                    if hasDuplicateTemplateName {
                        Text("Template name already exists.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

                Section("Fields") {
                    ForEach(Array(viewModel.fields.enumerated()), id: \.element.id) { index, _ in
                        HStack(spacing: 12) {
                            TextField(
                                "Field name",
                                text: Binding(
                                    get: { viewModel.fields[index].name },
                                    set: { viewModel.fields[index].name = $0 }
                                )
                            )

                            Picker(
                                "Type",
                                selection: Binding(
                                    get: { viewModel.fields[index].type },
                                    set: { viewModel.fields[index].type = $0 }
                                )
                            ) {
                                ForEach(fieldTypeOptions, id: \.self) { type in
                                    Text(type.displayName).tag(type)
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(.menu)
                        }
                    }
                    .onDelete(perform: viewModel.removeField)

                    Button {
                        viewModel.addField()
                    } label: {
                        Label("Add Field", systemImage: "plus")
                    }
                    .disabled(!viewModel.canAddField)
                }
            }
            .navigationTitle("New Template")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let createdTemplate = viewModel.create(in: context)
                        onCreate(createdTemplate)
                        dismiss()
                    }
                    .disabled(!canCreate)
                }
            }
        }
    }
}

private extension FieldType {
    var displayName: String {
        switch self {
        case .text: return "Text"
        case .number: return "Number"
        case .date: return "Date"
        case .boolean: return "Yes/No"
        }
    }
}

#Preview {
    let container = MockData.containerWithSampleData()

    CreateTemplateView { _ in }
        .modelContainer(container)
}
