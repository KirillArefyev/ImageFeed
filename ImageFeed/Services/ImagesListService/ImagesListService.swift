//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Кирилл Арефьев on 13.01.2024.
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void)
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListService: ImagesListServiceProtocol {
    static let shared = ImagesListService()
    private init() { }
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private (set) var photos: [Photo] = []
    private var pageNumber: Int = 1
    // MARK: - Methods
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }
        task?.cancel()
        guard let request = listPhotosRequest(pageNumber) else { return }
        let task = objectNextPageTask(for: request) { [weak self] result in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let photoResults):
                self.photos.append(contentsOf: photoResults.map { Photo(from: $0) })
                completion(.success(self.photos))
                NotificationCenter.default
                    .post(
                        name: ImagesListService.DidChangeNotification,
                        object: self,
                        userInfo: ["Photos": self.photos])
                self.pageNumber += 1
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }
        task?.cancel()
        guard let request = likePhotosRequest(photoId: photoId, isLiked: isLiked) else { return }
        let task = objectLikeTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success:
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    self.photos[index].isLiked = isLiked
                }
                completion(.success(()))
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
    private func objectNextPageTask(
        for request: URLRequest,
        completion: @escaping (Result<[PhotoResult], Error>) -> Void
    ) -> URLSessionTask {
        return urlSession.objectForTask(for: request) { (result: Result<[PhotoResult], Error>) in
            completion(result)
        }
    }
    
    private func objectLikeTask(
        for request: URLRequest,
        completion: @escaping (Result<LikePhotoResult, Error>) -> Void
    ) -> URLSessionTask {
        return urlSession.objectForTask(for: request) { (result: Result<LikePhotoResult, Error>) in
            completion(result)
        }
    }
    
    private func listPhotosRequest(_ page: Int) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos"
            + "?page=\(page)",
            httpMethod: "GET"
        )
        guard let token = oauth2TokenStorage.token else { return nil }
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func likePhotosRequest(photoId: String, isLiked: Bool) -> URLRequest? {
        let method = isLiked ? "POST" : "DELETE"
        var request = URLRequest.makeHTTPRequest(
            path: "/photos"
            + "/\(photoId)"
            + "/like",
            httpMethod: method
        )
        guard let token = oauth2TokenStorage.token else { return nil }
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
