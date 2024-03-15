//
//  ImagesListServiceStub.swift
//  ImageFeedTests
//
//  Created by Кирилл Арефьев on 13.03.2024.
//

import Foundation
@testable import ImageFeed

final class ImagesListServiceStub: ImagesListServiceProtocol {
    var photos: [Photo] = [Photo(from: PhotoResult(
        id: "0",
        createdAt: "1 января 2000",
        width: 0.0,
        height: 1.1,
        description: "test",
        isLiked: false,
        urlResult: .init(
            full: "full",
            thumb: "thumb"))
    )]
    
    var photosNextPageCalled = false
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], any Error>) -> Void) {
        photosNextPageCalled = true
    }
    
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Result<Void, any Error>) -> Void) { }
}
