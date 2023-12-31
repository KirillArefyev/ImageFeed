//
//  UserResult.swift
//  ImageFeed
//
//  Created by Кирилл on 25.12.2023.
//

import Foundation

struct UserResult: Codable {
    struct ProfileImage: Codable {
        let small: String
    }
    
    let profileImage: ProfileImage
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
