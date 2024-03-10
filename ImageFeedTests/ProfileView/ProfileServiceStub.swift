//
//  ProfileServiceStub.swift
//  ImageFeedTests
//
//  Created by Кирилл Арефьев on 08.03.2024.
//

import Foundation
@testable import ImageFeed

final class ProfileServiceStub: ProfileServiceProtocol {
    var profile: Profile? = Profile(from: ProfileResult(
        username: "username",
        firstName: "firstName",
        lastName: "lastName",
        bio: "bio"))
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) { }
}
