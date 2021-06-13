//
//  AppDelegate.swift
//  Walnut
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate
{
    // MARK: - Variables
    
    static var shared: AppDelegate { UIApplication.shared.delegate as! AppDelegate }
    private var container = { try! Container(modelName: "Model") }()
    
    var context: Context { container.context }
    
    // MARK: - Functions
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>)
    {
    }
}
