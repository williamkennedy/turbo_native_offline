//
//  EditToDoView.swift
//  TurboOffLineTodo
//
//  Created by William Kennedy on 23/01/2024.
//

import SwiftUI

struct EditTodoView: View {
    var appDatabase: AppDatabase = AppDatabase.shared
    @Binding var isPresented: Bool
    @State var todo: Todo

    var body: some View {
        Form {
            Section("Create ToDo") {
                TextField("Title", text: $todo.title)
            }

            Section {
                Button {
                    Task {
                        do {
                            try appDatabase.updateToDo(&todo)
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
    EditTodoView(isPresented: .constant(false), todo: Todo(title: "", complete: false, createdAt: Date(), updatedAt: Date()))
}
