//
//  AppDelegate.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 13/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit
import Swinject


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var coordinator: AppCoordinator!
    private var appAssembler: Assembler!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let container = Container()
        container.register(UIWindow.self) { (_) in self.window! }
        appAssembler = Assembler([AppAssembly()], container: container)
       
        coordinator = container.resolve(AppCoordinator.self)!
        coordinator.appDidLaunch(options: launchOptions)

        return true
    }
}

