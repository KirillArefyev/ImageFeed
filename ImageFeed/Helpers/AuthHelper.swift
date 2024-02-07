//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Кирилл Арефьев on 06.02.2024.
//

import Foundation
import WebKit

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from navigationAction: WKNavigationAction) -> String?
}

class AuthHelper: AuthHelperProtocol {
    // MARK: - Public Properties
    let configuration: AuthConfiguration
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    // MARK: - Public Methods
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil }
        return URLRequest(url: url)
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    // MARK: - Private Methods
    private func authURL() -> URL? {
        var urlComponents = URLComponents(string: configuration.authURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        return urlComponents?.url
    }
}
