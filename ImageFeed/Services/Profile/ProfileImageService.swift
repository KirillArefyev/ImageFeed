//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Кирилл on 25.12.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    init() { }
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastUsername: String?
    private (set) var avatarURL: String?
    // MARK: - Public Methods
    func fetchProfileImageURL(_ token: String, username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastUsername == username { return }
        task?.cancel()
        lastUsername = username
        let request = profileImageRequest(token, username: username)
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let profileImageURL = body.profileImage.small
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL])
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastUsername = nil
            }
        }
        self.task = task
        task.resume()
    }
}
// MARK: - Extensions
extension ProfileImageService {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<UserResult, Error>) -> Void
    ) -> URLSessionTask {
            return urlSession.objectForTask(for: request) { (result: Result<UserResult, Error>) in
                completion(result)
            }
        }
    
    private func profileImageRequest(_ token: String, username: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
