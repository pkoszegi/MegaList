//
//  EditItemSheet.swift
//  MegaList
//
//  Created by Petra Koszegi on 21/11/2025.
//

import SwiftUI

struct EditItemSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: EditItemViewModel
    let categories: [Category]

    @FocusState private var nameIsFocused: Bool
    @State private var showCategoryPicker = false

    init(item: MegaItem, categories: [Category]) {
        _viewModel = State(wrappedValue: EditItemViewModel(item: item))
        self.categories = categories
    }

    var body: some View {
        NavigationStack {
            Form {
                
                Section("Name") {
                    TextField("Item name", text: $viewModel.item.name)
                        .focused($nameIsFocused)
                }

                
                Section("Category") {
                    Button {
                        showCategoryPicker = true
                    } label: {
                        HStack {
                            Text("Category")
                            Spacer()
                            Text(viewModel.item.category?.emoji ?? "None")
                                .font(.title3)
                        }
                    }
                }
                
                if let template = viewModel.item.parentList?.template {
                    TemplateFieldsSection(
                        template: template,
                        controller: viewModel.fieldController
                    )
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        viewModel.persistChanges()
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showCategoryPicker) {
                CategoryPickerView(
                    selectedCategory: Binding(
                        get: { viewModel.item.category },
                        set: { viewModel.item.category = $0 }
                    ),
                    usedCategories: viewModel.item.parentList?.items
                        .compactMap { $0.category } ?? [],
                    allCategories: categories
                )
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    nameIsFocused = true
                }
            }
        }
    }
}

//struct EditItemSheet: View {
//    @Environment(\.dismiss) private var dismiss
//    @Bindable var item: MegaItem
//    var categories: [Category]
//
//    @FocusState private var nameIsFocused: Bool
//    @State private var showCategoryPicker = false
//
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section("Name") {
//                    TextField("Item name", text: $item.name)
//                        .focused($nameIsFocused)
//                }
//
//                Section("Category") {
//                    Button {
//                        showCategoryPicker = true
//                    } label: {
//                        HStack {
//                            Text("Category")
//
//                            Spacer()
//
//                            Text(item.category?.emoji ?? "None")
//                                .font(.title3)
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Edit Item")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Done") {
//                        dismiss()
//                    }
//                }
//            }
//            .sheet(isPresented: $showCategoryPicker) {
//                CategoryPickerView(
//                    selectedCategory: Binding(
//                        get: { item.category },
//                        set: { item.category = $0 }
//                    ),
//                    usedCategories: item.parentList?.items.compactMap { $0.category } ?? [],
//                    allCategories: categories
//                )
//            }
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    nameIsFocused = true
//                }
//            }
//        }
//    }
//}
//
//struct EditItemSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        let item = MegaItem.samples.first!
//        
//        EditItemSheet(
//            item: item,
//            categories: MockData.sampleCategories
//        )
//        .previewDisplayName("Edit Item Sheet")
//    }
//}
