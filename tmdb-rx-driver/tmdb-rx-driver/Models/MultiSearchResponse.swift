//
//  MultiSearchResponse.swift
//  tmdb-rx-driver
//
//  Created by Prefect on 08.04.2022.
//

import Foundation

struct MultiSearchResponse: Decodable {
    let results: [SearchResult]
}

struct SearchResult: Decodable {
    let id: Int
    let name: String?
    let mediaType: MediaType
    let profileUrl: String?
    let posterUrl: String?
    let overview: String?
    let title: String?
    let releaseDate: String?
    let knownForTitles: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case mediaType = "media_type"
        case profileUrl = "profile_path"
        case posterUrl = "poster_path"
        case overview
        case title
        case releaseDate = "release_date"
        case knownForTitles = "known_for"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name)
        mediaType = try container.decode(MediaType.self, forKey: .mediaType)
        profileUrl = try? container.decode(String.self, forKey: .profileUrl)
        posterUrl = try? container.decode(String.self, forKey: .posterUrl)
        overview = try? container.decode(String.self, forKey: .overview)
        title = try? container.decode(String.self, forKey: .title)
        releaseDate = try? container.decode(String.self, forKey: .releaseDate)
        let known = try? container.nestedUnkeyedContainer(forKey: .knownForTitles)
        var titles: [String]? = nil
        if var safeknown = known {
            while safeknown.isAtEnd {
                if let knownForDecodable = try? safeknown.decode(KnownFor.self),
                    let title = knownForDecodable.title {
                    titles?.append(title)
                }
            }
        }
        knownForTitles = titles
    }
}

enum MediaType: String, Decodable {
    case movie = "movie"
    case person = "person"
    case tv = "tv"
}
