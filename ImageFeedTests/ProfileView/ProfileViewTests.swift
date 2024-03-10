//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Кирилл Арефьев on 05.03.2024.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsPresenterUpdateProfileData() throws {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.updateProfileDataCalled)
    }
    
    func testSetupAvatarWithUpdateAvatarURL() throws {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(profileService: ProfileServiceStub(), profileImageService: ProfileImageServiceStub())
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.updateProfileData()
        
        //then
        XCTAssertTrue(viewController.setupAvatarCalled)
        XCTAssertEqual(viewController.presenter.profileImageService.avatarURL, "https://test.com")
    }
    
    func testSetupProfileDetailsWithUpdateProfileDetails() throws {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(profileService: ProfileServiceStub(), profileImageService: ProfileImageServiceStub())
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.updateProfileData()
        
        //then
        XCTAssertTrue(viewController.setupProfileDetailsCalled)
        XCTAssertEqual(viewController.presenter.profileService.profile?.username, "username")
        XCTAssertEqual(viewController.presenter.profileService.profile?.name, "firstName lastName")
        XCTAssertEqual(viewController.presenter.profileService.profile?.loginName, "@username")
        XCTAssertEqual(viewController.presenter.profileService.profile?.bio, "bio")
    }
}
