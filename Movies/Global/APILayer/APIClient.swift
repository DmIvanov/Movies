//
//  APIClient.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 13/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import Foundation

typealias RequestCompletion = (Data?, Error?) -> ()


class APIClient {

    // MARK: - Properties
    private let queue = DispatchQueue(label: "APIRequestsQueue")
    private lazy var session: URLSession = URLSession(configuration: .default)

    func getNowPlayingMovies(page: Int, completion: @escaping RequestCompletion) {
        let url = APIURLConstructor().urlNowPlaying(page: page)
        makeRequest(url: url, completion: completion)
    }

    func searchMovies(query: String, page: Int, completion: @escaping RequestCompletion) {
        let url = APIURLConstructor().urlSearch(query: query, page: page)
        makeRequest(url: url, completion: completion)
    }


    // MARK: - Private
    private func makeRequest(url: URL, completion: @escaping RequestCompletion) {
        queue.sync {
            let request = URLRequest(url: url)
            let task = session.dataTask(
                with: request,
                completionHandler: { (data, response, error) in
                    completion(data, error)
            })
            task.resume()
        }
    }
}
