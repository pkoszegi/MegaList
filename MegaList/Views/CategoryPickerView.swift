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
    var usedCategories: [Category]
    var allCategories: [Category]
    
    @State private var showAddSheet = false

    var unusedCategories: [Category] { allCategories.filter{ !usedCategories.contains($0) } }
    
    var body: some View {
        NavigationStack {
            List {
                if !usedCategories.isEmpty {
                    Section("Used in this list") {
                        ForEach(usedCategories) { category in
                            CategoryRow(category: category, isSelected: selectedCategory == category)
                                .onTapGesture {
                                    selectedCategory = category
                                    dismiss()
                                }
                        }
                    }
                }

                if !unusedCategories.isEmpty {
                    Section("Other categories") {
                        ForEach(unusedCategories) { category in
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
                        showAddSheet = true
                    } label: {
                        Label("Add New Category", systemImage: "plus.circle")
                    }
                }
            }
            .navigationTitle("Select Category")
            .sheet(isPresented: $showAddSheet) {
                AddCategorySheet { newCategory in
                    if allCategories.contains(where: {
                        $0.name.lowercased() == newCategory.name.lowercased() ||
                        $0.emoji == newCategory.emoji
                    }) {
                        print("Duplicate categories not allowed")
                        showAddSheet = false
                        return
                    }

                    context.insert(newCategory)
                    selectedCategory = newCategory
                    showAddSheet = false
                    dismiss()
                }
            }
        }
    }
}

struct CategoryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let list = MockData.sampleList
        let firstItem = list.items.first!

        let usedCategories = Array(Set(list.items.compactMap { $0.category }))

        CategoryPickerView(
            selectedCategory: .constant(firstItem.category),
            usedCategories: usedCategories,
            allCategories: MockData.sampleCategories
        )
    }
}

