//
//  ListVC.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 13/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit
import PureLayout


class ListVC: UIViewController {

    // MARK: - Properties
    private let cellID = "CellID"

    private let dataModel: ListVCDataModel

    fileprivate var collectionView: UICollectionView!
    fileprivate var collectionViewLayout: UICollectionViewFlowLayout!
    fileprivate var searchController: UISearchController!


    // MARK: - Lifecycle
    init(dataModel: ListVCDataModel) {
        self.dataModel = dataModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        view.backgroundColor = UIColor.black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        adjustNavigationItem()
        loadCollectionView()
        configureSearchController()
        dataModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        adjustCollectionViewLayout(toSize: size)
    }


    // MARK: - View loading
    private func loadCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createCollectionViewLayout()
        )
        collectionView.register(
            ListVCCell.self,
            forCellWithReuseIdentifier: cellID
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.black
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
        adjustCollectionViewLayout(toSize: view!.bounds.size)
    }

    private func createCollectionViewLayout() -> UICollectionViewLayout {
        collectionViewLayout = UICollectionViewFlowLayout()
        return collectionViewLayout as UICollectionViewLayout
    }

    private func adjustCollectionViewLayout(toSize: CGSize) {
        let cellsInRow: CGFloat = UIDevice.current.orientation.isLandscape ? 3 : 2
        let width = toSize.width / CGFloat(cellsInRow)
        let height = width * 1.5
        collectionViewLayout.itemSize = CGSize(width: width, height: height)
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
    }

    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .minimal
        definesPresentationContext = true
    }

    private func adjustNavigationItem() {
        switch dataModel.vcMode {
        case .nowPlaying:
            navigationItem.searchController = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .search,
                target: self,
                action: #selector(searchPressed)
            )
        case .search:
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.rightBarButtonItem = nil
        }
    }

    // MARK: - Actions
    @objc private func searchPressed() {
        dataModel.changeSearchState()
        searchController.searchBar.showsCancelButton = true
        adjustNavigationItem()
    }
}


extension ListVC: ListVCDataModelView {
    func refresh() {
        collectionView.reloadData()
    }
}


extension ListVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataModel.itemWasSelected(index: indexPath.item)
    }
}


extension ListVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.moviesAmount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ListVCCell
        if let cellModel = dataModel.model(index: indexPath.item) {
            cell.update(model: cellModel)
        }
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


extension ListVC: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        guard !text.isEmpty else { return }
        dataModel.filterContentForSearchText(text)
    }
}


extension ListVC: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataModel.searchCancelled()
        adjustNavigationItem()
    }
}
