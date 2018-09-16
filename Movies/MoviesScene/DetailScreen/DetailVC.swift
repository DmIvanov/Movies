//
//  DetailVC.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 13/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit
import PureLayout


class DetailVC: UIViewController {

    // MARK: - Properties
    private let movie: Movie

    private var poster: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!

    // MARK: - Lifecycle
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Details"
        view.backgroundColor = UIColor.black
        constructView()
        if let posterURL = movie.posterURLString() {
            ImageCache.sharedInstance.getImage(urlString: posterURL) { [weak self] (image, url) in
                if image != nil {
                    self?.poster.image = image
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - Public

    // MARK: - Private
    private func constructView() {
        poster = UIImageView(image: nil)
        poster.contentMode = .scaleAspectFit
        view.addSubview(poster)
        poster.autoPinEdge(toSuperviewSafeArea: .leading)
        poster.autoPinEdge(toSuperviewSafeArea: .trailing)
        poster.autoPinEdge(toSuperviewSafeArea: .top, withInset: 4)
        poster.autoMatch(.height, to: .width, of: poster, withMultiplier: 0.7)

        titleLabel = UILabel(forAutoLayout: ())
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor.white
        titleLabel.text = movie.title
        view.addSubview(titleLabel)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 8)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 8)
        titleLabel.autoPinEdge(.top, to: .bottom, of: poster, withOffset: 12)

        descriptionLabel = UILabel(forAutoLayout: ())
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.text = movie.overview
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        descriptionLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 8)
        descriptionLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 8)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 12)
    }
}
