//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Кирилл on 18.12.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private init() { }
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var tokenForRequest: String?
    private (set) var profile: Profile?
    // MARK: - Public Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if tokenForRequest == token { return }
        task?.cancel()
        tokenForRequest = token
        guard let request = profileRequest(token) else { return }
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                profile = Profile(from: body)
                guard let profile = profile else { return }
                self.profile = profile
                completion(.success(profile))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.tokenForRequest = nil
            }
        }
        self.task = task
        task.resume()
    }
}
// MARK: - Extensions
extension ProfileService {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        return urlSession.objectForTask(for: request) { (result: Result<ProfileResult, Error>) in
            completion(result)
        }
    }
    
    private func profileRequest(_ token: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
