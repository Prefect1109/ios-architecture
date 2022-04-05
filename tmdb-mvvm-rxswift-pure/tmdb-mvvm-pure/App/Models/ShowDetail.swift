//
//  ShowDetail.swift
//  tmdb-mvvm-pure
//
//  Created by Prefect on 05.04.2022.
//  Copyright © 2022 tailec. All rights reserved.
//

import Foundation

import Foundation

struct ShowDetail: Decodable {
    let id: Int
    let name: String
    let posterUrl: String?
    let genres: [Genre]?
    let releaseDate: String
    let overview: String
    let episodeRunTime: [Int]
    let voteAverage: Double?
    let voteCount: Int?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterUrl = "poster_path"
        case genres
        case releaseDate = "first_air_date"
        case overview
        case episodeRunTime = "episode_run_time"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case status
    }
}
