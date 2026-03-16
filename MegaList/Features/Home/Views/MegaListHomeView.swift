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
    @State private var listCreationVM = ListCreationViewModel()
    @State private var selectedList: MegaList?
    
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
                ListCreationSheet(
                    isPresented: $showingAddSheet,
                    viewModel: listCreationVM
                ) { createdList in
                    selectedList = createdList
                }
            }
            .onChange(of: showingAddSheet) { _, isPresented in
                if !isPresented {
                    listCreationVM.reset()
                }
            }
            .navigationDestination(item: $selectedList) { list in
                MegaListDetailView(list: list)
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
