//
//  ExpandableListCreationSheet.swift
//  MegaList
//
//  Created by Petra Koszegi on 17/11/2025.
//

import SwiftData
import SwiftUI

struct ExpandableListCreationSheet: View {
    @Environment(\.modelContext) private var context

    @Binding var isPresented: Bool
    @Bindable var viewModel: ListCreationViewModel

    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("List title", text: $viewModel.title)
                        .focused($isFocused)
                }

                Section {
                    NavigationLink {
                        TemplatePickerView(
                            availableTemplates: { customTemplates in
                                viewModel.availableTemplates(customTemplates: customTemplates)
                            },
                            selectedTemplate: $viewModel.selectedTemplate
                        ) { createdTemplate in
                            viewModel.didCreateTemplate(createdTemplate)
                        }
                    } label: {
                        HStack {
                            Text("Template")
                            Spacer()
                            Text(viewModel.selectedTemplate?.name ?? "None")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Create List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        viewModel.create(in: context)
                        isPresented = false
                    }
                    .disabled(!viewModel.canCreate)
                }
            }
        }
        .onAppear {
            isFocused = true
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    let container = MockData.containerWithSampleData()

    ExpandableListCreationSheet(
        isPresented: .constant(true),
        viewModel: ListCreationViewModel()
    )
    .modelContainer(container)
}
