//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Кирилл on 11.11.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell, ImagesListCellProtocol {
    static var reuseIdentifier = "ImagesListCell"
    // MARK: - IB Outlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView! {
        didSet {
            makeGradientView()
        }
    }
    // MARK: - Overrides Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    // MARK: - Public Methods
    func configurate(with model: ImagesListCellModel) {
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(
            with: URL(string: model.imageUrl),
            placeholder: UIImage(named: "image_stub"))
        favoriteButton.setImage(model.likeImage, for: .normal)
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
