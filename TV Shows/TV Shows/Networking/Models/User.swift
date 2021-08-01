//
//  User.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2021..
//

import Foundation

struct UserResponse: Codable {
    let user: User
}

struct User: Codable {
    let email: String
    let imageUrl: String?
    let id: String

    enum CodingKeys: String, CodingKey {
        case email
        case imageUrl = "image_url"
        case id
    }
}
