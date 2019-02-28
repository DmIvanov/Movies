//
//  APINowPlayingModel.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 13/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import Foundation


struct APIResponseModel: Codable {
    let results: [Movie]
    let page: Int
    let total_results: Int
    let total_pages: Int
}


final class APINowPlayingModelParser {
    func parse(data: Data?) -> APIResponseModel? {
        guard let data = data else { return nil }
        do {
            let model = try JSONDecoder().decode(APIResponseModel.self, from: data)
            return model
        } catch {
            print("Error. JSON Serialization: \(error.localizedDescription)")
            return nil
        }
    }
}
