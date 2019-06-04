//
//  MovieModelView.swift
//  iOSShowcaseApp
//
//  Created by Umang Davessar on 3/6/19.
//  Copyright © 2019 Umang Davessar. All rights reserved.
//

import Foundation


public struct MovieListResponse: Codable {
    public let page: Int
    public let totalResults: Int
    public let totalPages: Int
    public let results: [MovieListKeys]
}

public struct MovieListKeys: Codable {
    
    public let id: Int
    public let title: String
    public let posterPath: String?
    public let overview: String
    public var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
}

