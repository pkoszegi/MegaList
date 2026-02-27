//
//  BottomInputSheet.swift
//  MegaList
//
//  Created by Petra Koszegi on 17/11/2025.
//

import SwiftData
import SwiftUI

struct ExpandableListCreationSheet: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \ListTemplate.name) private var customTemplates: [ListTemplate]

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
                    Picker("Template", selection: $viewModel.selectedTemplate) {
                        Text("None").tag(nil as ListTemplate?)
                        ForEach(viewModel.availableTemplates(customTemplates: customTemplates)) { template in
                            Text(template.name).tag(template as ListTemplate?)
                        }
                    }

                    Button {
                        viewModel.showingCreateTemplate = true
                    } label: {
                        Label("New Template", systemImage: "plus.circle")
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
        .sheet(isPresented: $viewModel.showingCreateTemplate) {
            CreateTemplateView { createdTemplate in
                viewModel.didCreateTemplate(createdTemplate)
            }
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
