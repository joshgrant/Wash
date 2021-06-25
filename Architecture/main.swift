//
//  main.swift
//  Walnut
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

// Entry point for the application

let principalClassName: String? = NSStringFromClass(Application.self)
let delegateClassName: String? = NSStringFromClass(AppDelegate.self)

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    principalClassName,
    delegateClassName)
