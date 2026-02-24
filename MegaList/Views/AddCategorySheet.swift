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
    
    @State private var showingCustomEmojiInput = false
    
    let usedEmojis: Set<String>
    var onAdd: (Category) -> Void

    var availableEmojis: [String] {
        EmojiRepository.defaults.filter { !usedEmojis.contains($0) }
    }
    
    var canCreate: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !emoji.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Category name", text: $name)
                        .overlay(alignment: .trailing) {
                            Text(emoji)
                        }
                }

                Section {
                    EmojiPickerView(
                        selectedEmoji: $emoji,
                        emojis: availableEmojis
                    )
                }
                header: {
                    HStack {
                        Text("Emoji")
                        Spacer()
                        Button {
                            showingCustomEmojiInput = true
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                
            }
            .sheet(isPresented: $showingCustomEmojiInput) {
                CustomEmojiInputView(
                    usedEmojis: usedEmojis
                ) { newEmoji in
                    emoji = newEmoji
                }
                .presentationDetents([.medium])
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        onAdd(
                            Category(
                                name: name.trimmingCharacters(in: .whitespaces),
                                emoji: emoji)
                        )
                    }
                    .disabled(!canCreate)
                }
            }
        }
    }
}


struct AddCategorySheet_Previews: PreviewProvider {
    static var previews: some View {
        
        AddCategorySheet(usedEmojis: []) { newCategory in
            print(newCategory.name)
        }
        .previewDisplayName("Add Category Sheet")
    }
}
