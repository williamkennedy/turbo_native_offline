//
//  ToDoViewController.swift
//  TurboOffLineTodo
//
//  Created by William Kennedy on 15/01/2024.
//

import Foundation
import UIKit
import TurboNavigator
import SwiftUI

class ToDoViewController: UIHostingController<TodoIndex>, PathConfigurationIdentifiable {
    static var pathConfigurationIdentifier: String { "todos" }

    init() {
        super.init(rootView: TodoIndex())
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
