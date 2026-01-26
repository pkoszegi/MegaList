//
//  CategoryRow.swift
//  MegaList
//
//  Created by Petra Koszegi on 17/11/2025.
//

import SwiftUI

struct CategoryRow: View {
    var category: Category
    var isSelected: Bool

    var body: some View {
        HStack {
            Text(category.emoji)
                .font(.title2)

            Text(category.name)
                .font(.body)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CategoryRow(category: Category(name: "Category", emoji: "👻"), isSelected: false)
}
