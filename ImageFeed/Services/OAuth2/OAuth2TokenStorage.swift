//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Кирилл on 11.12.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    init() { }
    // MARK: - Private Properties
    private let keychainWrapper = KeychainWrapper.standard
    private let tokenStorage = "token"
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: tokenStorage)
        }
        set {
            guard let newValue = newValue else { return }
            keychainWrapper.set(newValue, forKey: tokenStorage)
        }
    }
    // MARK: - Public Methods
    func removeToken() {
        keychainWrapper.removeObject(forKey: tokenStorage)
    }
}
