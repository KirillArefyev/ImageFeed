//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Кирилл on 11.11.2023.
//

import Kingfisher
import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell, ImagesListCellProtocol {
    static var reuseIdentifier = "ImagesListCell"
    // MARK: - IB Outlets
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView! {
        didSet {
            makeGradientView()
        }
    }
    // MARK: - Properties
    weak var delegate: ImagesListCellDelegate?
    // MARK: - Overrides Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    // MARK: - IB Actions
    @IBAction private func likeButtonClicked() {
        delegate?.imagesListCellDidTapLike(self)
    }
    // MARK: - Methods
    func configurate(with model: ImagesListCellModel) {
        cellImage.kf.setImage(
            with: URL(string: model.imageUrl),
            placeholder: UIImage(named: "image_stub"))
        favoriteButton.setImage(model.likeImage, for: .normal)
        favoriteButton.accessibilityIdentifier = "favoriteButton"
        dateLabel.text = model.date
    }
    // MARK: - Private Methods
    private func makeGradientView() {
        let gradient = CAGradientLayer()
        let firstColor = UIColor.ifBlack.withAlphaComponent(0.0).cgColor
        let secondColor = UIColor.ifBlack.withAlphaComponent(0.2).cgColor
        gradient.colors = [firstColor, secondColor]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.locations = [0.0, 1.0]
        gradient.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradient)
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = gradientView.frame
        rectShape.position = gradientView.center
        rectShape.path = UIBezierPath(
            roundedRect: gradientView.bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: 16, height: 16)
        ).cgPath
        gradientView.layer.mask = rectShape
    }
}
