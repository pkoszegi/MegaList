//
//  MegaItemRow.swift
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
        VStack(alignment: .leading) {
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
                
                if let emoji = item.category?.emoji {
                    Button {
                        if let onCategoryTap {
                            onCategoryTap()
                        }
                    } label : {
                        Text(emoji)
                            .font(.system(size: 22))
                    }
                    .buttonStyle(.plain)
                }
            }
                
            HStack {
                let populatedFieldValues = item.fieldValues
                    .sorted {
                        if $0.sortOrder != $1.sortOrder {
                            return $0.sortOrder < $1.sortOrder
                        }
                        return $0.fieldName.localizedCaseInsensitiveCompare($1.fieldName) == .orderedAscending
                    }
                    .compactMap(\.displayStringIfValuePresent)
                if !populatedFieldValues.isEmpty {
                    Text(populatedFieldValues.joined(separator: " • "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)
                }
            }
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
        let list = try? context.fetch(FetchDescriptor<MegaList>())
            .first(where: { !$0.items.isEmpty })

        Group {
            if let list, list.items.count >= 2 {
                let item1 = list.items[0]
                let item2 = list.items[1]

                MegaItemRow(item: item1, onCategoryTap: {}, onEdit: {}, onDelete: {})
                MegaItemRow(item: item2, onCategoryTap: {}, onEdit: {}, onDelete: {})
            } else {
                Text("Preview unavailable")
            }
        }
        .modelContainer(container)
        .previewLayout(.sizeThatFits)
    }
}
