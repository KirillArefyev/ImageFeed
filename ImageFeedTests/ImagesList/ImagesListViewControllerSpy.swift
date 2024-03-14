//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Кирилл Арефьев on 13.03.2024.
//

import Foundation
@testable import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol!
    
    var setupLikeCalled = false
    
    func updateTableViewAnimated() { }
    
    func setupLike(for cell: ImagesListCell) {
        setupLikeCalled = true
    }
}
