//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Кирилл on 11.12.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let userDefault = UserDefaults.standard
    private let tokenStorage = "token"
    
    var token: String? {
        get {
            userDefault.string(forKey: tokenStorage)
        }
        set {
            userDefault.set(newValue, forKey: tokenStorage)
        }
    }
}
