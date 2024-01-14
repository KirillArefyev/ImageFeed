//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Кирилл Арефьев on 13.01.2024.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: Date?
    let width: Double
    let height: Double
    let description: String
    let isLiked: Bool
    let urlResult: UrlResult
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case isLiked = "liked_by_user"
        case urlResult
    }
}

struct UrlResult: Codable {
    let full: String
    let thumb: String
}
