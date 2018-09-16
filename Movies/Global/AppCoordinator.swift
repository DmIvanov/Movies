//
//  AppCoordinator.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 13/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit


class AppCoordinator: NSObject {

    // MARK: - Properties
    private let presenter: Presenting
    fileprivate let dataService: DataServiceProtocol

    // MARK: - Lyfecycle
    init(mainWindow: UIWindow) {
        self.dataService = ServicesFactory.dataService()
        self.presenter = ServicesFactory.presenter(window: mainWindow)
    }


    // MARK: - Public
    func appDidLaunch(options: [UIApplication.LaunchOptionsKey: Any]?) {
        goToListScreen()
    }


    // MARK: - Private
    fileprivate func goToListScreen() {
        let listVC = MoviesVCFactory.listVC(
            dataService: dataService,
            delegate: self
        )
        presenter.resetWindow(vc: listVC)
    }

    fileprivate func goToDetailView(movie: Movie) {
        let detailVC = MoviesVCFactory.detailVC(
            movie: movie
        )
        presenter.push(vc: detailVC, animated: true)
    }
}


// ----------------------------------------------------------------------------
// MARK: - ListSceneDelegate
// ----------------------------------------------------------------------------
extension AppCoordinator: ListSceneDelegate {
    func movieWasChosen(movie: Movie) {
        goToDetailView(movie: movie)
    }
}
