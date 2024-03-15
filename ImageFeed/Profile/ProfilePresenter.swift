//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Кирилл Арефьев on 23.02.2024.
//

import Foundation
import WebKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    var profileService: ProfileServiceProtocol { get }
    var profileImageService: ProfileImageServiceProtocol { get }
    
    func updateProfileData()
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    // MARK: - Public Properties
    weak var view: ProfileViewControllerProtocol?
    var profileService: ProfileServiceProtocol
    var profileImageService: ProfileImageServiceProtocol
    // MARK: - Private Properties
    private var oauth2TokenStorage = OAuth2TokenStorage.shared
    private var splashViewController = SplashViewController()
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(profileService: ProfileServiceProtocol = ProfileService.shared, profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    // MARK: - Public Methods
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(
                    ofTypes: record.dataTypes,
                    for: [record],
                    completionHandler: { })
            }
        }
    }
    
    func updateProfileData() {
        observeProfileImageService()
        updateProfileDetails()
        updateAvatar()
    }
    
    func logout() {
        oauth2TokenStorage.removeToken()
        Self.clean()
        returnToAuthenticationScreen()
    }
    // MARK: - Private Methods
    private func observeProfileImageService() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        view?.setupProfileDetails(profile)
    }
    
    @objc private func updateAvatar() {
        guard
            let profileImageURL = self.profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.setupAvatar(with: url)
    }
    
    private func returnToAuthenticationScreen() {
        DispatchQueue.main.async {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController?.present(self.splashViewController, animated: true)
            }
        }
    }
}
