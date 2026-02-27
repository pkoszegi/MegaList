//
//  MegaListItemRow.swift
//  MegaList
//
//  Created by Petra Koszegi on 17/11/2025.
//

import SwiftUI
import SwiftData

struct MegaItemRow: View {
    @Bindable var item: MegaItem
    var onCategoryTap: (() -> Void)?
    let onEdit: (() -> Void)?
    let onDelete: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.spring()) {
                    item.isDone.toggle()
                }
            } label: {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(item.isDone ? Color.accentColor : .secondary)
            }
            .buttonStyle(.plain)
            
            Text(item.name)
                .foregroundStyle(item.isDone ? .secondary : .primary)
                .animation(.default, value: item.isDone)
            
            Spacer()
            
            
            Button {
                if let onCategoryTap {
                    onCategoryTap()
                }
            } label : {
                if let emoji = item.category?.emoji {
                    Text(emoji)
                        .font(.system(size: 22))
                } else {
                    Image(systemName: "tag")
                }
            }
            .buttonStyle(.plain)
            
            
        }
        .swipeActions {
            if let onEdit {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                }
                .tint(.blue)
            }

            if let onDelete {
                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                }
            }
        }
        .padding(.vertical, 6)
    }
}

struct MegaItemRow_Previews: PreviewProvider {
    static var previews: some View {
        let container = MockData.containerWithSampleData()
        let context = container.mainContext
        let list = try! context.fetch(FetchDescriptor<MegaList>())
            .first(where: { !$0.items.isEmpty })!
        let item1 = list.items[0]
        let item2 = list.items[1]

        Group {
            MegaItemRow(item: item1, onCategoryTap: {}, onEdit: {}, onDelete: {})
            MegaItemRow(item: item2, onCategoryTap: {}, onEdit: {}, onDelete: {})
        }
        .modelContainer(container)
        .previewLayout(.sizeThatFits)
    }
}
