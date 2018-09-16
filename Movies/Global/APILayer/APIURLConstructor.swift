//
//  APIURLConstructor.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 14/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit

private let apiKey = "315b17d12701d865feec38ecbe299886"


class APIURLConstructor: NSObject {

    // MARK: - Public
    func urlNowPlaying(page: Int) -> URL {
        var components = baseComponents(forEndpoint: APIEndpoint.nowPlaying)
        components.queryItems = [
            apiKeyItem(),
            pageItem(page)
        ]
        return components.url!
    }

    func urlSearch(query: String, page: Int) -> URL {
        var components = baseComponents(forEndpoint: APIEndpoint.search)
        components.queryItems = [
            apiKeyItem(),
            pageItem(page),
            queryItem(query)
        ]
        return components.url!
    }

    // MARK: - Private
    private func baseComponents(forEndpoint endpoint: APIEndpoint) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/\(endpoint.rawValue)"
        return components
    }

    private func apiKeyItem() -> URLQueryItem {
        return URLQueryItem(name: "api_key", value: apiKey)
    }

    private func pageItem(_ page: Int) -> URLQueryItem {
        return URLQueryItem(name: "page", value: "\(page)")
    }

    private func queryItem(_ query: String) -> URLQueryItem {
        return URLQueryItem(name: "query", value: query)
    }
}


enum APIEndpoint: String {
    case nowPlaying = "movie/now_playing"
    case search = "search/movie"
}
