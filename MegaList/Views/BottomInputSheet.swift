//
//  BottomInputSheet.swift
//  MegaList
//
//  Created by Petra Koszegi on 17/11/2025.
//

import SwiftUI

struct BottomInputSheet: View {
    @Binding var isPresented: Bool
    var title: String
    var placeholder: String
    @Binding var text: String
    var actionTitle: String = "Add"
    var action:() -> Void
    
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
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
                
                TextField(placeholder, text: $text)
                    .textFieldStyle(.roundedBorder)
                    .focused($isFocused)
                    .padding(.horizontal)
                
                Button(actionTitle) {
                    guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    action()
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
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
        .onAppear {
            DispatchQueue.main.async {
                isFocused = true
            }
        }
        .presentationDetents([.height(200)])
    }
}

#Preview {
    BottomInputSheet(isPresented: .constant(true), title: "Title", placeholder: "Enter title", text: .constant(""), action: { print("Action triggered") })
}
