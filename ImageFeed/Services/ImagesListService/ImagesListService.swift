//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Кирилл Арефьев on 13.01.2024.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    private init() { }
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    // MARK: - Methods
    func fetchPhotosNextPage(completion: @escaping (Result<[PhotoResult], Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }
        task?.cancel()
        let nextPage = lastLoadedPage == nil ? 1 : (lastLoadedPage ?? 0) + 1
        guard let request = listPhotosRequest(nextPage) else { return }
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photoResults):
                for photoResult in photoResults {
                    self.photos.append(Photo(from: photoResult))
                }
                completion(.success(photoResults))
                NotificationCenter.default
                    .post(
                        name: ImagesListService.DidChangeNotification,
                        object: self,
                        userInfo: ["Photos": self.photos])
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
// MARK: - Extensions
extension ImagesListService {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<[PhotoResult], Error>) -> Void
    ) -> URLSessionTask {
        return urlSession.objectForTask(for: request) { (result: Result<[PhotoResult], Error>) in
            completion(result)
        }
    }
    
    private func listPhotosRequest(_ page: Int) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(path: "/photos"
                                                 + "?page=\(page)", httpMethod: "GET")
        guard let token = oauth2TokenStorage.token else { return nil}
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
