//
//  AppDelegate.swift
//  Craven Connections
//
//  Created by Craven on 5/4/23.
//

import UIKit
import Firebase
import FirebaseUI


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }

}

func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
    let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
    return FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication, annotation: annotation) ?? false
}
