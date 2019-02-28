//
//  ListVCCell.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 13/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit
import PureLayout


class ListVCCell: UICollectionViewCell {

    // MARK: - Properties
    private let imageView: UIImageView
    private let errorLabel: UILabel

    private var currentImageURL: String?


    // MARK: - Lifecycle
    override init(frame: CGRect) {
        imageView = UIImageView(forAutoLayout: ())
        errorLabel = UILabel(forAutoLayout: ())

        super.init(frame: frame)

        addSubview(imageView)
        imageView.autoPinEdgesToSuperviewEdges()

        addSubview(errorLabel)
        errorLabel.autoCenterInSuperview()
        errorLabel.backgroundColor = UIColor.white
        errorLabel.isHidden = true

        setPlaceholderImage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    override func prepareForReuse() {
        super.prepareForReuse()
        errorLabel.isHidden = true
        setPlaceholderImage()
    }

    func update(model: ListCellModel) {
        currentImageURL = model.imageURLString
        errorLabel.text = "Image loading error"
        if let posterURL = model.imageURLString {
            ImageCache.sharedInstance.getImage(urlString: posterURL) { [weak self] (image, url) in
                guard url == self?.currentImageURL else { return }
                if image != nil {
                    self?.imageView.image = image
                    self?.imageView.contentMode = .scaleAspectFill
                } else {
                    self?.errorLabel.isHidden = false
                }
            }
        } else {
            errorLabel.text = model.movieTitle
            errorLabel.numberOfLines = 0
            errorLabel.isHidden = false
        }
    }


    // MARK: - Private
    private func setPlaceholderImage() {
        let placeholder = UIImage(named: "film-camera.jpg")
        imageView.image = placeholder
        imageView.contentMode = .scaleAspectFit
    }
}
