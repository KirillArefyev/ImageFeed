//
//  Photo.swift
//  ImageFeed
//
//  Created by Кирилл Арефьев on 13.01.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(from result: PhotoResult) {
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        self.createdAt = result.createdAt
        self.welcomeDescription = result.description
        self.thumbImageURL = result.urlResult.thumb
        self.largeImageURL = result.urlResult.full
        self.isLiked = result.isLiked
    }
}
