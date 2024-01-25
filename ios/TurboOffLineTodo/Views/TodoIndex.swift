//
//  TodoIndex.swift
//  TurboOffLineTodo
//
//  Created by William Kennedy on 15/01/2024.
//

import SwiftUI

struct TodoIndex: View {
    var appDatabase: AppDatabase = AppDatabase.shared
    @State private var todos: [Todo] = []
    @State private var showingNewSheet = false
    @State private var showingEditSheet = false
    @State private var selectedTodo: Todo?

    var body: some View {
        List {
            ForEach(todos, id: \.id) { todo in
                Text("ID: \(todo.id ?? 0) \(todo.title)")
                    .swipeActions {
                        Button {
                            selectedTodo = todo
                            showingEditSheet.toggle()
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }

                    }
                    .tint(.green)
            }
            .onDelete(perform: deleteToDo)
        }
        .onAppear {
            getToDos()
        }
        .toolbar(id: "Actions") {
            ToolbarItem(id: "Add", placement: .primaryAction) {
                Button {
                    showingNewSheet.toggle()
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
        .sheet(isPresented: $showingNewSheet, onDismiss: getToDos, content: {
            NewTodoView(isPresented: $showingNewSheet)
        })
        .sheet(isPresented: $showingEditSheet, onDismiss: getToDos, content: {
            if let todo = selectedTodo {
                EditTodoView(isPresented: $showingEditSheet, todo: todo)
            }
        })
    }

    func createRandomToDo() {
        do {
            try appDatabase.createRandomToDo()
        } catch {
            print(error.localizedDescription)
        }
        getToDos()
    }

    func getToDos() {
        do {
            todos = try appDatabase.getToDos()
        } catch {
            print(error.localizedDescription)
        }
    }

    func deleteToDo(at offsets: IndexSet) {
        for offset in offsets {
            let todo = todos[offset]
            do {
                try appDatabase.deleteToDo(todo)
            } catch {
                print(error.localizedDescription)
            }
        }
        getToDos()
    }
}

#Preview {
    NavigationView {
        TodoIndex()
    }
}
