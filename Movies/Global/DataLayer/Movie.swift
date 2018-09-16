//
//  Movie.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 13/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit

class Movie: Codable {

    let vote_count: Int
    let id: Int
    let video: Bool
    let vote_average: Double
    let title: String
    let popularity: Double
    let poster_path: String?
    let backdrop_path: String?
    let original_language: String
    let original_title: String
    let overview: String
    let release_date: String

    func posterURLString() -> String? {
        guard let path = poster_path else { return nil }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }

    func backdropURLString() -> String? {
        guard let path = backdrop_path else { return posterURLString() }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
}
