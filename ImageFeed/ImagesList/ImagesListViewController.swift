//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Кирилл on 08.11.2023.
//

import Kingfisher
import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol! { get set }
    var alertPresenter: AlertPresenterProtocol? { get set }
    var tableView: UITableView! { get set }
    
    func viewDidLoad()
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol, ImagesListCellDelegate {
    // MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Public Properties
    var presenter: ImagesListPresenterProtocol!
    var alertPresenter: AlertPresenterProtocol?
    // MARK: - Private Properties
    private let showSingleImageSegueIdentifer = "ShowSingleImage"
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        presenter = ImagesListPresenter()
        presenter.view = self
        alertPresenter = AlertPresenter(delegate: self)
        presenter.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifer {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else { return }
            viewController.fullImageUrl = presenter.photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    // MARK: - Public Methods
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        presenter.cellTapLike(cell)
    }
}
// MARK: - Extensions
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifer, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photoSize = presenter.photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photoSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photoSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = presenter.photos[indexPath.row]
        let isLiked = photo.isLiked
        guard let favoriteImage = isLiked ? UIImage(named: "favorite_active") : UIImage(named: "favorite_no_active") else { return }
        let cellModel = ImagesListCellModel(
            imageUrl: photo.thumbImageURL,
            likeImage: favoriteImage,
            date: photo.createdAt?.dateString ?? "")
        cell.configurate(with: cellModel)
        cell.delegate = self
    }
}

extension ImagesListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1) == presenter.photos.count && !ProcessInfo().arguments.contains("testMode") {
            UIBlockingProgressHUD.show()
            presenter.imagesListService.fetchPhotosNextPage(completion: { _ in })
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = presenter.photos.count
        let newCount = presenter.imagesListService.photos.count
        presenter.photos = presenter.imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}
