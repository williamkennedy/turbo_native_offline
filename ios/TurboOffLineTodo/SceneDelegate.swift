//
//  SceneDelegate.swift
//  TurboOffLineTodo
//
//  Created by William Kennedy on 14/01/2024.
//

import Turbo
import TurboNavigator
import UIKit

let baseURL = URL(string: "http://todo.test")!

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?


    private lazy var pathConfiguration = PathConfiguration(sources: [
        .file(Bundle.main.url(forResource: "ios-v1", withExtension: "json")!),
        .server(baseURL.appendingPathComponent("/turbo/ios/configurations/ios_v1.json")
               )
    ])
    private lazy var turboNavigator = TurboNavigator(delegate: self, pathConfiguration: pathConfiguration)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        self.window = UIWindow(windowScene: windowScene)
        self.window?.makeKeyAndVisible()

        self.window?.rootViewController = self.turboNavigator.rootViewController
        self.turboNavigator.route(baseURL)
    }
}

extension SceneDelegate: TurboNavigationDelegate {
    func handle(proposal: VisitProposal) -> ProposalResult {
        if proposal.viewController == ToDoViewController.pathConfigurationIdentifier {
            return .acceptCustom(ToDoViewController())
        } else {
            return .accept
        }

    }

    func visitableDidFailRequest(_ visitable: Visitable, error: Error, retry: @escaping RetryBlock) {
        if (error as NSError).code == -1004 || (error as NSError).code == -1009 {
            self.window?.rootViewController = ToDoViewController()
//            turboNavigator.navigationController.pushViewController(ToDoViewController(), animated: true)
        }else if let errorPresenter = visitable as? ErrorPresenter {
            errorPresenter.presentError(error) {
                retry()
            }
        }
    }
}
