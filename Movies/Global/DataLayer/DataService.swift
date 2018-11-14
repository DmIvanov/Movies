//
//  DataService.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 13/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import Foundation

let dataServiceMoviesRefreshedNotification = NSNotification.Name(rawValue: "dataServiceMoviesRefreshedNotification")


class DataService: DataServiceProtocol {

    // MARK: - Properties
    private let apiClient: APIClient
    
    private(set) var movies = [Movie]()
    private(set) var currentQuery: String?

    private var amountOfPages: Int?
    private var lastLoadedPage: Int?
    private let resourceSyncQueue = DispatchQueue(label: "com.movies.dataServiceSync")

    // MARK: - Lifecycle
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    // MARK: - Public
    func loadNowPlayingMovies(nextPage: Bool) {
        let pageToLoad = lastLoadedPage != nil ? lastLoadedPage!+1 : 1
        if amountOfPages != nil {
            guard pageToLoad <= amountOfPages! else { return }
        }

        apiClient.getNowPlayingMovies(page: pageToLoad) { [weak self] (data, error) in
            self?.processMoviesResponse(data: data, error: error)
        }
    }

    func searchMovies(query: String, nextPage: Bool) {
        if query != currentQuery {
            resetMovies()
        } else if !nextPage {
            return
        }
        currentQuery = query
        
        let pageToLoad = lastLoadedPage != nil ? lastLoadedPage!+1 : 1
        if amountOfPages != nil {
            guard pageToLoad <= amountOfPages! else { return }
        }

        apiClient.searchMovies(query: query, page: pageToLoad) { [weak self] (data, error) in
            self?.processMoviesResponse(data: data, error: error)
        }
    }

    func cancelSearch() {
        resetMovies()
    }

    // MARK: - Private
    private func processMoviesResponse(data: Data?, error: Error?) {
        guard let responseModel = APINowPlayingModelParser().parse(data: data) else { return }
        resourceSyncQueue.sync {
            movies.append(contentsOf: responseModel.results)
            amountOfPages = responseModel.total_pages
            lastLoadedPage = responseModel.page
        }
        NotificationCenter.default.post(name: dataServiceMoviesRefreshedNotification, object: self)
    }

    private func resetMovies() {
        resourceSyncQueue.sync {
            movies = [Movie]()
            amountOfPages = nil
            lastLoadedPage = nil
        }
        NotificationCenter.default.post(name: dataServiceMoviesRefreshedNotification, object: self)
    }
}


protocol DataServiceProtocol: AnyObject {
    var movies: [Movie] { get }
    var currentQuery: String? { get }
    func loadNowPlayingMovies(nextPage: Bool)
    func searchMovies(query: String, nextPage: Bool)
    func cancelSearch()
}
