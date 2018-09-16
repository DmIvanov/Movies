//
//  ListVCDataModel.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 13/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit


class ListVCDataModel {

    // MARK: - Properties
    weak var view: ListVCDataModelView?

    private weak var dataService: DataServiceProtocol?
    private weak var delegate: ListSceneDelegate?

    private var moviesToDisplay = [Movie]()
    private(set) var vcMode = ListVCMode.nowPlaying

    private var loading = false

    // MARK: - Lifecycle
    init(dataService: DataServiceProtocol, delegate: ListSceneDelegate) {
        self.delegate = delegate
        self.dataService = dataService
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(moviesRefreshed),
            name: dataServiceMoviesRefreshedNotification,
            object: dataService
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    // MARK: - Public
    func viewDidLoad() {
        dataService?.loadNowPlayingMovies(nextPage: false)
    }

    func moviesAmount() -> Int {
        return moviesToDisplay.count
    }

    func model(index: Int) -> ListCellModel? {
        guard index >= 0 && index < moviesToDisplay.count else { return nil }
        if moviesToDisplay.count - index < 10 {
            tryToLoadMore()
        }
        return ListCellModel(movie: moviesToDisplay[index])
    }

    func itemWasSelected(index: Int) {
        delegate?.movieWasChosen(movie: moviesToDisplay[index])
    }

    func filterContentForSearchText(_ searchText: String) {
        dataService?.searchMovies(query: searchText, nextPage: false)
    }

    func changeSearchState() {
        switch vcMode {
        case .nowPlaying:
            vcMode = .search
        case .search:
            vcMode = .nowPlaying
        }
    }

    func searchCancelled() {
        dataService?.cancelSearch()
        changeSearchState()
        dataService?.loadNowPlayingMovies(nextPage: false)
    }

    // MARK: - Private
    private func tryToLoadMore() {
        guard let dataService = dataService else { return }
        guard !loading  else { return }
        loading = true
        switch vcMode {
        case .nowPlaying:
            dataService.loadNowPlayingMovies(nextPage: true)
        case .search:
            guard let query = dataService.currentQuery else { return }
            dataService.searchMovies(query: query, nextPage: true)
        }
    }

    @objc private func moviesRefreshed() {
        guard let dataService = dataService else { return }
        moviesToDisplay = dataService.movies
        DispatchQueue.main.async { [weak self] in
            self?.loading = false
            self?.view?.refresh()
        }
    }
}


protocol ListSceneDelegate: AnyObject {
    func movieWasChosen(movie: Movie)
}


protocol ListVCDataModelView: AnyObject {
    func refresh()
}


struct ListCellModel {

    let movieID: Int
    let imageURLString: String?
    let movieTitle: String

    init(movie: Movie) {
        imageURLString = movie.posterURLString()
        movieID = movie.id
        movieTitle = movie.title
    }
}


enum ListVCMode {
    case nowPlaying, search
}
