//
//  AddCategorySheet.swift
//  MegaList
//
//  Created by Petra Koszegi on 17/11/2025.
//

import SwiftUI

struct AddCategorySheet: View {
    @State private var viewModel: AddCategoryViewModel

    var onAdd: (Category) -> Void

    init(usedEmojis: Set<String>, onAdd: @escaping (Category) -> Void) {
        _viewModel = State(wrappedValue: AddCategoryViewModel(usedEmojis: usedEmojis))
        self.onAdd = onAdd
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Category name", text: $viewModel.name)
                        .overlay(alignment: .trailing) {
                            Text(viewModel.emoji)
                        }
                }

                Section {
                    EmojiPickerView(
                        selectedEmoji: $viewModel.emoji,
                        emojis: viewModel.availableEmojis
                    )
                }
                header: {
                    HStack {
                        Text("Emoji")
                        Spacer()
                        Button {
                            viewModel.showingCustomEmojiInput = true
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                
            }
            .sheet(isPresented: $viewModel.showingCustomEmojiInput) {
                CustomEmojiInputView(
                    usedEmojis: viewModel.usedEmojis
                ) { newEmoji in
                    viewModel.applyCustomEmoji(newEmoji)
                }
                .presentationDetents([.medium])
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        onAdd(viewModel.buildCategory())
                    }
                    .disabled(!viewModel.canCreate)
                }
            }
        }
    }
}


struct AddCategorySheet_Previews: PreviewProvider {
    static var previews: some View {
        AddCategorySheet(
            usedEmojis: Set(MockData.sampleCategories().map(\.emoji))
        ) { newCategory in
            print(newCategory.name)
        }
        .previewDisplayName("Add Category Sheet")
    }
}
