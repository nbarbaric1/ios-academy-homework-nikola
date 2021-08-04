//
//  ShowsResponse.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2021..
//

import Foundation

struct ShowsResponse: Decodable {
    let shows: [Show]
    let meta: Meta
}

struct Show: Decodable {
    let id: String
    let averageRating: Int?
    let description: String?
    let imageUrl: String
    let numberOfReviews: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case averageRating = "average_rating"
        case description
        case imageUrl = "image_url"
        case numberOfReviews = "no_of_reviews"
        case title
    }
}

struct Meta: Decodable {
    let pagination: Pagination
}

struct Pagination: Decodable {
    let count: Int
    let page: Int
    let items: Int
    let pages: Int
}
