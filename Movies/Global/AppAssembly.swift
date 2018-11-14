//
//  AppAssembly.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 13/11/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import Foundation
import Swinject


class AppAssembly: Assembly {

    func assemble(container: Container) {
        container.register(Presenter.self) { (resolver) in
            Presenter(window: resolver.resolve(UIWindow.self)!)
        }
        container.register(APIClient.self) { (_) in
            APIClient()
        }
        container.register(DataService.self) { (resolver) in
            DataService(apiClient: resolver.resolve(APIClient.self)!)
        }
        container.register(AppCoordinator.self) { (resolver) in
            AppCoordinator(
                presenter: resolver.resolve(Presenter.self)!,
                dataService: resolver.resolve(DataService.self)!
            )
        }
    }
}
