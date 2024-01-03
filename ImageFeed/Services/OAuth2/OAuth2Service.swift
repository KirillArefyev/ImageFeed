//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Кирилл on 11.12.2023.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() { }
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private (set) var authToken: String? {
        get {
            return oauth2TokenStorage.token
        }
        set {
            oauth2TokenStorage.token = newValue
        }
    }
    private var task:  URLSessionTask?
    private var lastCode: String?
    // MARK: - Public Methods
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        let request = authTokenRequest(code)
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}
// MARK: - Extensions
extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        return urlSession.objectForTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            completion(result)
        }
    }
    
    private func authTokenRequest(_ code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(accessKey)"
            + "&&client_secret=\(secretKey)"
            + "&&redirect_uri=\(redirectUri)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseUrl: URL(string: "https://unsplash.com")!
        )
    }
}
