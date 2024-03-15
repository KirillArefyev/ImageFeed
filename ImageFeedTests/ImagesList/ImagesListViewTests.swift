//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Кирилл Арефьев on 13.03.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListViewTests: XCTestCase {
    func testViewControllerCallsPresenterViewDidLoad() throws {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsFetchNextPage() throws {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenter()
        let imagesListService = ImagesListServiceStub()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.imagesListService = imagesListService

        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(imagesListService.photosNextPageCalled)
        XCTAssertEqual(imagesListService.photos.count, 1)
        XCTAssertEqual(imagesListService.photos[0].thumbImageURL, "thumb")
    }
    
    func testPresenterCallsSetupLike() throws {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        let cell = ImagesListCell()
        
        //when
        presenter.imagesListCellDidTapLike(cell)
        
        //then
        XCTAssertTrue(viewController.setupLikeCalled)
    }
}
