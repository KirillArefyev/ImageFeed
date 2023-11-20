//
//  TableView+Extensions.swift
//  ImageFeed
//
//  Created by Кирилл on 11.11.2023.
//

import UIKit

//private let photosName: [String] = Array(0..<20).map{ "\($0)" }
//
//extension ImagesListViewController {
//    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
//        guard let image = UIImage(named: photosName[indexPath.row]) else {
//            return
//        }
//        
//        cell.cellImage.image = image
//        cell.dateLabel.text = Date().dateString
//        
//        let isLiked = indexPath.row % 2 == 0
//        let favoriteImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
//        cell.favoriteButton.setImage(favoriteImage, for: .normal)
//    }
//}
//
//extension ImagesListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let image = UIImage(named: photosName[indexPath.row]) else {
//            return 0
//        }
//        
//        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
//        let imageWidth = image.size.width
//        let scale = imageViewWidth / imageWidth
//        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
//        
//        return cellHeight
//    }
//}
//
//extension ImagesListViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return photosName.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
//        
//        guard let imageListCell = cell as? ImagesListCell else {
//            return UITableViewCell()
//        }
//        
//        configCell(for: imageListCell, with: indexPath)
//        
//        return imageListCell
//    }
//}
