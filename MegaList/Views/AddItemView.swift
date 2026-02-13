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
    
    init(list: MegaList) {
        self.list = list
        _viewModel = State(wrappedValue: AddItemViewModel(list: list))
    }
    
    @State private var showingCategoryPicker: Bool = false
    
    var body: some View {
        NavigationStack {
            
            List {
                TextField("Item name", text: $viewModel.name)
                    .font(.title2)
                    .padding(.vertical, 8)
                
                Button {
                    showingCategoryPicker = true
                } label: {
                    HStack {
                        Text("Category")
                        Spacer()
                        Text(viewModel.selectedCategory?.emoji ?? "🏷️")
                            .foregroundStyle(.secondary)
                    }
                }
                
                
                if let templateFields = list.template?.fields {
                    ForEach(templateFields) { field in
                        switch field.type {

                        case .text:
                            TextField(field.name,
                                      text: viewModel.textBinding(for: field))

                        case .boolean:
                            Toggle(field.name,
                                   isOn: viewModel.boolBinding(for: field))

                        case .date:
                            DatePicker(field.name,
                                       selection: viewModel.dateBinding(for: field),
                                       displayedComponents: .date)

                        case .number:
                            TextField(field.name,
                                      value: viewModel.numberBinding(for: field),
                                      format: .number)
                                .keyboardType(.decimalPad)
                        }
                    }
                }

                
                Button("Create") {
                    if(viewModel.canCreate) {
                        viewModel.createItem(in: context)
                        dismiss()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .navigationDestination(isPresented: $showingCategoryPicker) {
            CategoryPickerView(
                selectedCategory: $viewModel.selectedCategory,
                usedCategories: [],
                allCategories: categories
            )
        }
        .navigationTitle("New Item")
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

