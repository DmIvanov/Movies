//
//  MoviesVCFactory.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 13/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit

class MoviesVCFactory {

    class func listVC(dataService: DataServiceProtocol, delegate: ListSceneDelegate) -> ListVC {
        let model = ListVCDataModel(
            dataService: dataService,
            delegate: delegate
        )
        let vc = ListVC(dataModel: model)
        model.view = vc
        return vc
    }

    class func detailVC(movie: Movie) -> DetailVC {
        let vc = DetailVC(movie: movie)
        return vc
    }
}
