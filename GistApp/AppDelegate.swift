//
//  AppDelegate.swift
//  GistApp
//
//  Created by User on 08/08/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let firstScreen = GistViewController()
        let navController = UINavigationController(rootViewController: firstScreen)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        
        return true
    }



}

