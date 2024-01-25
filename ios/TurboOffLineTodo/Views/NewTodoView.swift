//
//  NewTodoView.swift
//  TurboOffLineTodo
//
//  Created by William Kennedy on 22/01/2024.
//

import SwiftUI

struct NewTodoView: View {
    var appDatabase: AppDatabase = AppDatabase.shared
    @Binding var isPresented: Bool
    @State private var title = ""
    var body: some View {
        Form {
            Section("Create ToDo") {
                TextField("Title", text: $title)
            }

            Section {
                Button {
                    Task {
                        let todo = Todo(title: title, complete: false, createdAt: Date(), updatedAt: Date())
                        do {
                            try appDatabase.createToDo(todo)
                        } catch {
                            print(error.localizedDescription)
                        }
                        isPresented = false
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                }


            }
        }
    }
}

#Preview {
    NewTodoView(isPresented: .constant(false))
}
