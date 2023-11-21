//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Кирилл on 21.11.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private var userPhotoView: UIImageView!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var loginLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var exitButton: UIButton!
    // MARK: - IB Actions
    @IBAction private func exitButtonTapped(_ sender: UIButton) {
    }
}