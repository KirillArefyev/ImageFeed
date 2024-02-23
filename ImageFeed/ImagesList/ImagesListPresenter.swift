//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Кирилл Арефьев on 22.02.2024.
//

import Foundation
import UIKit

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    var imagesListService: ImagesListService { get }
    
    func viewDidLoad()
    func updateTableViewAnimated()
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
}

final class ImagesListPresenter: ImagesListPresenterProtocol, ImagesListCellDelegate {
    // MARK: - Public Properties
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var imagesListService = ImagesListService.shared
    // MARK: - Private Properties
    private var alertPresenter: AlertPresenterProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(viewController: ImagesListViewControllerProtocol?) {
        self.view = viewController
        self.alertPresenter = AlertPresenter(delegate: viewController as? UIViewController)
    }
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
                self.updateTableViewAnimated()
            }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                view?.tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
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
                alertPresenter?.showError(errorAlert)
            }
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let isLiked = photos[indexPath.row].isLiked
        guard let favoriteImage = isLiked ? UIImage(named: "favorite_active") : UIImage(named: "favorite_no_active") else { return }
        let cellModel = ImagesListCellModel(
            imageUrl: photos[indexPath.row].thumbImageURL,
            likeImage: favoriteImage,
            date: photos[indexPath.row].createdAt?.dateString ?? "")
        cell.configurate(with: cellModel)
        cell.delegate = self
    }
}
