//
//  MegaListDetailView.swift
//  MegaList
//
//  Created by Petra Koszegi on 14/11/2025.
//
import SwiftData
import SwiftUI

struct MegaListDetailView: View {
    @Environment(\.modelContext) private var context

    @Bindable var list: MegaList
    @State private var viewModel = MegaListDetailViewModel()
    
    @State private var showAddItem = false
    
    @State private var itemBeingEdited: MegaItem?
    
    @State private var selectedItemForCategory: MegaItem?
    @State private var showingCategoryPicker = false
    
    @Query var categories: [Category]
    
    init(list: MegaList) {
        self.list = list
    }
    
    var usedCategories: [Category] {
        viewModel.usedCategories(from: list.items)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                ForEach(viewModel.activeItems(from: list.items)) { item in
                    MegaItemRow(
                        item: item,
                        onCategoryTap: {
                            selectedItemForCategory = item
                            showingCategoryPicker = true
                        },
                        onEdit: {
                            itemBeingEdited = item
                        },
                        onDelete: {
                            context.delete(item)
                        }
                    )
                }
                
                ForEach(viewModel.completedItems(from: list.items)) { item in
                    MegaItemRow(
                        item: item,
                        onCategoryTap: nil,
                        onEdit: nil,
                        onDelete: {
                            context.delete(item)
                        }
                    )
                    
                }
            }
            
            VStack {
                Button {
                    showAddItem = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle($list.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showAddItem) {
            AddItemView(list: list)
        }
        .navigationDestination(isPresented: $showingCategoryPicker) {
            if let item = selectedItemForCategory {
                CategoryPickerView(
                    selectedCategory: Binding(
                        get: { item.category },
                        set: { item.category = $0 }
                    ),
                    usedCategories: usedCategories,
                    allCategories: categories)
            }
        }
        .sheet(item: $itemBeingEdited) { editing in
            EditItemSheet(item: editing, categories: categories)
        }
    }
}

struct MegaListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let container = MockData.containerWithSampleData()
        let context = container.mainContext
        let list = try? context.fetch(FetchDescriptor<MegaList>())
            .first(where: { !$0.items.isEmpty })

        Group {
            if let list {
                MegaListDetailView(list: list)
            } else {
                Text("Preview unavailable")
            }
        }
        .modelContainer(container)
        .previewDisplayName("MegaList Detail View")
    }
}
