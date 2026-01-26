//
//  MegaListHomeView.swift
//  MegaList
//
//  Created by Petra Koszegi on 14/11/2025.
//
import SwiftData
import SwiftUI

struct MegaListHomeView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \MegaList.title) private var lists: [MegaList]
    
    @State private var showingAddSheet = false
    @State private var newListTitle = ""
    
    @FocusState private var isTitleFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(lists) { list in
                    NavigationLink(list.title) {
                        MegaListDetailView(list: list)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(lists[index])
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                BottomInputSheet(
                    isPresented: $showingAddSheet,
                    title: "Create New List",
                    placeholder: "Enter title",
                    text: $newListTitle,
                    actionTitle: "Add"
                ) {
                    let list = MegaList(title: newListTitle)
                    context.insert(list)
                    newListTitle = ""
                }
            }
            .navigationTitle("MegaList")
        }
    }
}

#Preview {
    let container = MockData.containerWithSampleData()
    
    return MegaListHomeView()
            .modelContainer(container)
}
