//
//  AppDatabase.swift
//  TurboOffLineTodo
//
//  Created by William Kennedy on 21/01/2024.
//

import Foundation
import GRDB
import os.log

struct AppDatabase {
    ///
    init(_ dbWriter: any DatabaseWriter) throws {
        self.dbWriter = dbWriter
        try migrator.migrate(dbWriter)
    }

    private let dbWriter: any DatabaseWriter
}


extension AppDatabase {
    private static let sqlLogger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SQL")

    public static func makeConfiguration(_ base: Configuration = Configuration()) -> Configuration {
        var config = base



        // Log SQL statements if the `SQL_TRACE` environment variable is set.
        // See <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/database/trace(options:_:)>
        if ProcessInfo.processInfo.environment["SQL_TRACE"] != nil {
            config.prepareDatabase { db in
                db.trace {
                    // It's ok to log statements publicly. Sensitive
                    // information (statement arguments) are not logged
                    // unless config.publicStatementArguments is set
                    // (see below).
                    os_log("%{public}@", log: sqlLogger, type: .debug, String(describing: $0))
                }
            }
        }

#if DEBUG
        // Protect sensitive information by enabling verbose debugging in
        // DEBUG builds only.
        // See <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/configuration/publicstatementarguments>
        config.publicStatementArguments = true
#endif

        return config
    }
}

// MARK: - Database Migrations

extension AppDatabase {
    ///
    /// See <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/migrations>
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

#if DEBUG
        // Speed up development by nuking the database when migrations change
        // See <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/migrations>
        migrator.eraseDatabaseOnSchemaChange = true
#endif

        migrator.registerMigration("createToDo") { db in
            // Create a table
            // See <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/databaseschema>
            try db.create(table: "todo") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text).notNull()
                t.column("complete", .boolean).defaults(to: false)
                t.column("createdAt", .datetime)
                t.column("updatedAt", .datetime)
            }
        }

        return migrator
    }
}


extension AppDatabase {
    /// A validation error that prevents some players from being saved into
    /// the database.
    enum ValidationError: LocalizedError {
        case missingName

        var errorDescription: String? {
            switch self {
            case .missingName:
                return "Please provide a title"
            }
        }
    }

    func createToDo(_ todo: Todo) throws {
        try dbWriter.write { db in
            do {
                try todo.save(db)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func updateToDo(_ todo: inout Todo) throws {
        todo.updatedAt = Date()
        try dbWriter.write { db in
            do {
                try todo.save(db)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func createRandomToDo() throws {
        let todo = Todo(id: nil, title: UUID().uuidString, complete: false, createdAt: Date(), updatedAt: Date())

        try dbWriter.write { db in
            do {
                try todo.save(db)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func getToDos() throws -> [Todo] {
        var todos = [Todo]()
        try dbWriter.write { db in
            do {
                todos = try Todo.fetchAll(db)
            } catch {
                print(error.localizedDescription)
            }
        }
        return todos
    }

    func deleteToDo(_ todo: Todo)  throws {
        try  dbWriter.write { db in
            _ = try Todo.deleteAll(db, ids: [todo.id])
        }
    }
}

extension AppDatabase {
    var reader: DatabaseReader {
        dbWriter
    }
}
