//
//  Todo.swift
//  TurboOffLineTodo
//
//  Created by William Kennedy on 21/01/2024.
//

import Foundation
import GRDB

struct Todo: Identifiable, Codable, TableRecord, PersistableRecord, FetchableRecord {
    var id: Int64?
    var title: String
    var complete: Bool
    var createdAt: Date
    var updatedAt: Date
}

extension Todo: MutablePersistableRecord {
    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
