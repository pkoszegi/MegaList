//
//  AddCategorySheet.swift
//  MegaList
//
//  Created by Petra Koszegi on 17/11/2025.
//

import SwiftUI

struct AddCategorySheet: View {
    @State private var name = ""
    @State private var emoji = ""

    var onAdd: (Category) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Category name", text: $name)
                }

                Section("Emoji") {
                    TextField("Emoji", text: $emoji)
                        .autocorrectionDisabled()
                }

                Button("Create") {
                    guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
                          !emoji.trimmingCharacters(in: .whitespaces).isEmpty else { return }

                    onAdd(
                        Category(name: name.trimmingCharacters(in: .whitespaces),
                                 emoji: emoji.trimmingCharacters(in: .whitespaces))
                    )
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
            }
            .navigationTitle("New Category")
            .navigationBarTitleDisplayMode(.inline)
            .presentationDetents([.medium])
        }
    }
}


struct AddCategorySheet_Previews: PreviewProvider {
    static var previews: some View {
        
        AddCategorySheet { newCategory in
            print(newCategory.name)
        }
        .previewDisplayName("Add Category Sheet")
    }
}
