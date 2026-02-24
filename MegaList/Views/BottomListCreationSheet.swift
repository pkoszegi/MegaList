//
//  BottomInputSheet.swift
//  MegaList
//
//  Created by Petra Koszegi on 17/11/2025.
//

import SwiftUI

struct BottomListCreationSheet: View {
    @Environment(\.modelContext) private var context

    @Binding var isPresented: Bool
    @Bindable var viewModel: ListCreationViewModel

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Create list")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.accentColor)
                }
            }
            .padding()
            
            Divider()
            
            VStack(spacing: 16) {
                
                TextField("Enter title", text: $viewModel.title)
                    .textFieldStyle(.roundedBorder)
                    .focused($isFocused)
                    .padding(.horizontal)
                
                Picker("Template", selection: $viewModel.selectedTemplate) {
                    Text("Choose template").tag(nil as ListTemplate?)
                    ForEach(viewModel.availableTemplates) { template in
                        Text(template.name).tag(template as ListTemplate?)
                    }
                }
                
                Button("Add") {
                    viewModel.create(in: context)
                    isPresented = false
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .onAppear {
            isFocused = true
        }
        .presentationDetents([.height(250)])
    }
}

#Preview {
}
