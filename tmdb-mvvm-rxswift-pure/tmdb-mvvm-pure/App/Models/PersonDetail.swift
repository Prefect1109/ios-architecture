//
//  PersonDetail.swift
//  tmdb-mvvm-pure
//
//  Created by Prefect on 05.04.2022.
//  Copyright © 2022 tailec. All rights reserved.
//

import Foundation

struct PersonDetail: Codable {
    let name: String
    let profileUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case name, profileUrl = "profile_path"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        profileUrl = try? container.decode(String.self, forKey: .profileUrl)
    }
}
