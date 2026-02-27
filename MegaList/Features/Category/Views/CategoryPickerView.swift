//
//  CategoryPickerView.swift
//  MegaList
//
//  Created by Petra Koszegi on 17/11/2025.
//
import SwiftData
import SwiftUI

struct CategoryPickerView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedCategory: Category?
    @State private var viewModel: CategoryPickerViewModel

    init(selectedCategory: Binding<Category?>, usedCategories: [Category], allCategories: [Category]) {
        self._selectedCategory = selectedCategory
        _viewModel = State(
            wrappedValue: CategoryPickerViewModel(
                usedCategories: usedCategories,
                allCategories: allCategories
            )
        )
    }
    
    var body: some View {
        NavigationStack {
            List {
                if !viewModel.usedCategories.isEmpty {
                    Section("Used in this list") {
                        ForEach(viewModel.usedCategories) { category in
                            CategoryRow(category: category, isSelected: selectedCategory == category)
                                .onTapGesture {
                                    selectedCategory = category
                                    dismiss()
                                }
                        }
                    }
                }

                if !viewModel.unusedCategories.isEmpty {
                    Section("Other categories") {
                        ForEach(viewModel.unusedCategories) { category in
                            CategoryRow(category: category, isSelected: selectedCategory == category)
                                .onTapGesture {
                                    selectedCategory = category
                                    dismiss()
                                }
                        }
                    }
                }

                Section {
                    Button {
                        viewModel.showAddSheet = true
                    } label: {
                        Label("Add New Category", systemImage: "plus.circle")
                    }
                }
            }
            .navigationTitle("Select Category")
            .sheet(isPresented: $viewModel.showAddSheet) {
                AddCategorySheet(usedEmojis: viewModel.usedEmojis) { newCategory in
                    if viewModel.isDuplicate(newCategory) {
                        print("Duplicate categories not allowed")
                        viewModel.showAddSheet = false
                        return
                    }

                    context.insert(newCategory)
                    selectedCategory = newCategory
                    viewModel.showAddSheet = false
                    dismiss()
                }
            }
        }
    }
}

struct CategoryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let container = MockData.containerWithSampleData()
        let context = container.mainContext
        let lists = try! context.fetch(FetchDescriptor<MegaList>())
        let list = lists.first(where: { !$0.items.isEmpty }) ?? lists[0]
        let firstItem = list.items.first!
        let categories = try! context.fetch(FetchDescriptor<Category>())
        let usedCategories = Array(Set(list.items.compactMap { $0.category }))

        CategoryPickerView(
            selectedCategory: .constant(firstItem.category),
            usedCategories: usedCategories,
            allCategories: categories
        )
        .modelContainer(container)
    }
}
