//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Кирилл Арефьев on 13.03.2024.
//

import Foundation
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var imagesListService: ImagesListServiceProtocol
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListServiceStub()) {
        self.imagesListService = imagesListService
    }
    
    var viewDidLoadCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
