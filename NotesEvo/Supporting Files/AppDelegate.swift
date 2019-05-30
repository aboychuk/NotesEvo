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
            let viewController = UINavigationController(rootViewController: NoteListViewController())
            $0.rootViewController = viewController
            $0.makeKeyAndVisible()
        }
        
        return true
    }
}
