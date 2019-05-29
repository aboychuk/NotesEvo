//
//  AppDelegate.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/17/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.window {
            let note = Note(modifyDate: Date(), content: Constants.defaultContent.value)
            let model = [Note](repeating: note, count: 10)
            let viewController = UINavigationController(rootViewController: NoteListViewController(model: model))
            $0.rootViewController = viewController
            $0.makeKeyAndVisible()
        }
        
        return true
    }
}
