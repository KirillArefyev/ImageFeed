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
    var profileService: ProfileService { get }
    var profileImageService: ProfileImageService { get }
    
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    // MARK: - Public Properties
    weak var view: ProfileViewControllerProtocol?
    var profileService = ProfileService.shared
    var profileImageService = ProfileImageService.shared
    var oauth2TokenStorage = OAuth2TokenStorage.shared
    var splashViewController = SplashViewController()
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
    
    func logout() {
        oauth2TokenStorage.removeToken()
        Self.clean()
        returnToAuthenticationScreen()
    }
    // MARK: - Private Methods
    private func returnToAuthenticationScreen() {
        DispatchQueue.main.async {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController?.present(self.splashViewController, animated: true)
            }
        }
    }
}
