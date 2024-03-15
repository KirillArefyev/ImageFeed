//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Кирилл Арефьев on 22.02.2024.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    var imagesListService: ImagesListServiceProtocol { get }
    
    func viewDidLoad()
}

final class ImagesListPresenter: ImagesListPresenterProtocol, ImagesListCellDelegate {
    // MARK: - Public Properties
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var imagesListService: ImagesListServiceProtocol
    // MARK: - Private Properties
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
        self.imagesListService = imagesListService
    }
    // MARK: - Public Methods
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage(completion: { _ in })
        observeImagesListService()
    }
    
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        view?.setupLike(for: cell)
    }
    // MARK: - Private Methods
    private func observeImagesListService() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                UIBlockingProgressHUD.dismiss()
                self.view?.updateTableViewAnimated()
            }
    }
}
