//
//  ListCreationSheet.swift
//  MegaList
//
//  Created by Petra Koszegi on 17/11/2025.
//

import SwiftData
import SwiftUI

struct ListCreationSheet: View {
    @Environment(\.modelContext) private var context

    @Binding var isPresented: Bool
    @Bindable var viewModel: ListCreationViewModel
    var onCreate: (MegaList) -> Void = { _ in }

    @FocusState private var isFocused: Bool
    @State private var navigationPath: [ListCreationRoute] = []

    var body: some View {
        NavigationStack(path: $navigationPath) {
            Form {
                Section("Name") {
                    TextField("List title", text: $viewModel.title)
                        .focused($isFocused)
                }

                Section {
                    NavigationLink(value: ListCreationRoute.templatePicker) {
                        HStack {
                            Text("Template")
                            Spacer()
                            Text(viewModel.selectedTemplate?.name ?? "None")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationDestination(for: ListCreationRoute.self) { route in
                switch route {
                case .templatePicker:
                    TemplatePickerView(
                        availableTemplates: { customTemplates in
                            viewModel.availableTemplates(customTemplates: customTemplates)
                        },
                        selectedTemplate: $viewModel.selectedTemplate,
                        onSelect: {
                            navigationPath.removeAll()
                        },
                        onAddTemplate: {
                            navigationPath.append(.createTemplate)
                        }
                    )
                case .createTemplate:
                    CreateTemplateView(dismissOnCreate: false) { createdTemplate in
                        viewModel.didCreateTemplate(createdTemplate)
                        navigationPath.removeAll()
                    }
                }
            }
            .navigationTitle("Create List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.reset()
                        isPresented = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let list = viewModel.create(in: context)
                        isPresented = false
                        onCreate(list)
                    }
                    .disabled(!viewModel.canCreate)
                }
            }
        }
        .onAppear {
            isFocused = true
        }
    }
}

private enum ListCreationRoute: Hashable {
    case templatePicker
    case createTemplate
}

#Preview {
    let container = MockData.containerWithSampleData()

    ListCreationSheet(
        isPresented: .constant(true),
        viewModel: ListCreationViewModel()
    )
    .modelContainer(container)
}
