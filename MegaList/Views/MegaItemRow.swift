//
//  MegaListItemRow.swift
//  MegaList
//
//  Created by Petra Koszegi on 17/11/2025.
//

import SwiftUI

struct MegaItemRow: View {
    @Bindable var item: MegaItem
    var onCategoryTap: (() -> Void)

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
                onCategoryTap()
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
        .padding(.vertical, 6)
    }
}

struct MegaItemRow_Previews: PreviewProvider {
    static var item1 = MegaItem(name: "Item name 1", isDone: false)
    static var item2 = MegaItem(name: "Item name 2", isDone: true)

    static var previews: some View {
        Group {
            MegaItemRow(item: item1, onCategoryTap: {})
            MegaItemRow(item: item2, onCategoryTap: {})
        }
        .previewLayout(.sizeThatFits)
    }
}
