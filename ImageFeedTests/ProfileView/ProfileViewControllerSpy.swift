//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Кирилл Арефьев on 05.03.2024.
//

import Foundation
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol!
    
    var setupAvatarCalled = false
    var setupProfileDetailsCalled = false
    
    func setupAvatar(with url: URL) {
        setupAvatarCalled = true
    }
    
    func setupProfileDetails(_ profile: Profile) {
        setupProfileDetailsCalled = true
    }
}
