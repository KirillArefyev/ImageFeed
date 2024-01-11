//
//  Profile.swift
//  ImageFeed
//
//  Created by Кирилл on 20.12.2023.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    
    init(from profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.firstName ?? "")" + " \(profileResult.lastName ?? "")"
        self.loginName = "@\(username)"
        self.bio = profileResult.bio ?? "Hello, world!"
    }
}
