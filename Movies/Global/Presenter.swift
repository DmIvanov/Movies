//
//  Presenter.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 13/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit


class Presenter: Presenting {

    private var window: UIWindow
    private var rootNC: UINavigationController?

    init(window: UIWindow) {
        self.window = window
        window.makeKeyAndVisible()
    }

    func resetWindow(vc: UIViewController) {
        rootNC = UINavigationController(rootViewController: vc)
        rootNC?.navigationBar.barStyle = .blackTranslucent
        rootNC?.navigationBar.tintColor = UIColor.white
        window.rootViewController = rootNC!
    }

    func push(vc: UIViewController, animated: Bool) {
        rootNC?.pushViewController(vc, animated: animated)
    }
}


protocol Presenting {
    func resetWindow(vc: UIViewController)
    func push(vc: UIViewController, animated: Bool)
}
