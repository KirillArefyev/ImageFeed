//
//  ProfileImageServiceStub.swift
//  ImageFeedTests
//
//  Created by Кирилл Арефьев on 08.03.2024.
//

import Foundation
@testable import ImageFeed

final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    var avatarURL: String? = "https://test.com"
    
    func fetchProfileImageURL(_ token: String, username: String, completion: @escaping (Result<String, Error>) -> Void) { }
}
