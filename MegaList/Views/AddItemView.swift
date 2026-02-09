//
//  AddItemView.swift
//  MegaList
//
//  Created by Petra Koszegi on 09/02/2026.
//

import SwiftUI

struct AddItemView: View {
    let list: MegaList
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: AddItemViewModel
    
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
                        Text(viewModel.selectedCategory?.name ?? "None")
                            .foregroundStyle(.secondary)
                    }
                }
                
                
                if let templateFields = list.template?.fields {
                    if !templateFields.isEmpty {
                        ForEach(templateFields) { field in
                            Text(field.name)
                                .font(.title2)
                                .padding(.vertical, 8)
                            // TODO: figure out how to set values in viewmodel - TextField("Enter Value", text:
                        }
                    }
                }
                
                Button("Create") {
                    if(viewModel.canCreate) {
                        viewModel.createItem(in: context)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .navigationTitle("New Item")
    }
}

#Preview {
}
