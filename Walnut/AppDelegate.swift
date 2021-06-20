//
//  AppDelegate.swift
//  Walnut
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit
import ProgrammaticUI

typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]

class AppDelegate: UIResponder, UIApplicationDelegate
{
    // MARK: - Variables
    
    static var shared: AppDelegate { UIApplication.shared.delegate as! AppDelegate }
    
    var database = Database()
    
    // MARK: - Functions
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: LaunchOptions?) -> Bool { true }

    // MARK: - UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}
