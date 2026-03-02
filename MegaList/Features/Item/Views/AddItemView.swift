//
//  AddItemView.swift
//  MegaList
//
//  Created by Petra Koszegi on 09/02/2026.
//

import SwiftUI
import SwiftData

struct AddItemView: View {
    let list: MegaList
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query var categories: [Category]

    @State private var viewModel: AddItemViewModel
    @FocusState private var nameIsFocused: Bool
    
    init(list: MegaList) {
        self.list = list
        _viewModel = State(wrappedValue: AddItemViewModel(list: list))
    }
    
    @State private var showingCategoryPicker: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Item name", text: $viewModel.name)
                        .focused($nameIsFocused)
                }

                Section("Category") {
                    Button {
                        showingCategoryPicker = true
                    } label: {
                        HStack {
                            Text(viewModel.selectedCategory?.name ?? "None")
                            Spacer()
                            Text(viewModel.selectedCategory?.emoji ?? "")
                                .font(.title3)
                        }
                    }
                }

                if let template = list.template {
                    TemplateFieldsSection(
                        template: template,
                        controller: viewModel.fieldController
                    )
                }
            }
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        viewModel.createItem(in: context)
                        dismiss()
                    }
                    .disabled(!viewModel.canCreate)
                }
            }
            .sheet(isPresented: $showingCategoryPicker) {
                CategoryPickerView(
                    selectedCategory: $viewModel.selectedCategory,
                    usedCategories: viewModel.usedCategories,
                    allCategories: categories
                )
            }
            .onAppear {
                nameIsFocused = true
            }
        }
    }
}

#Preview {
    let container = MockData.containerWithSampleData()
    let context = container.mainContext

    let list = try! context.fetch(FetchDescriptor<MegaList>())
        .first(where: { $0.template != nil })!

    AddItemView(list: list)
        .modelContainer(container)
}
