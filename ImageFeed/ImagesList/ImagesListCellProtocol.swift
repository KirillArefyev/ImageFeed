//
//  ImagesListCellProtocol.swift
//  ImageFeed
//
//  Created by Кирилл on 03.12.2023.
//

import Foundation

protocol ImagesListCellProtocol {
    static var reuseIdentifier: String { get }
    
    func configurate(with model: ImagesListCellModel)
}
