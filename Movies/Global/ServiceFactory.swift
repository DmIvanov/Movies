//
//  ServiceFactory.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 13/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit

class ServicesFactory {

    #if TEST
    static var presenterMock: Presenting!
    #endif

    class func presenter(window: UIWindow) -> Presenting {
        #if TEST
        return presenterMock
        #else
        return Presenter(window: window)
        #endif
    }

    class func dataService() -> DataService {
        return DataService()
    }
}
