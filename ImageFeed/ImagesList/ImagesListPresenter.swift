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
    var imagesListService: ImagesListService { get }
    
    func viewDidLoad()
    func cellTapLike(_ cell: ImagesListCell)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    // MARK: - Public Properties
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var imagesListService = ImagesListService.shared
    // MARK: - Private Properties
    private var imagesListServiceObserver: NSObjectProtocol?
    // MARK: - Public Methods
    func viewDidLoad() {
        UIBlockingProgressHUD.show()
        self.imagesListService.fetchPhotosNextPage(completion: { _ in })
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                UIBlockingProgressHUD.dismiss()
                view?.updateTableViewAnimated()
            }
    }
    
    func cellTapLike(_ cell: ImagesListCell) {
        guard let indexPath = view?.tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLiked: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success:
                self.photos[indexPath.row].isLiked = !photo.isLiked
                self.view?.tableView.reloadRows(at: [indexPath], with: .none)
            case .failure:
                let errorAlert = ErrorAlertModel(
                    title: "Что-то пошло не так(",
                    message: "Попробуйте ещё раз",
                    buttonText: "ОК",
                    completion: { })
                view?.alertPresenter?.showError(errorAlert)
            }
        }
    }
}
