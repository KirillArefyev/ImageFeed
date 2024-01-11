//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Кирилл Арефьев on 03.01.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = .ifBlack
        UITabBar.appearance().tintColor = .ifWhite
        
        let storyboard = UIStoryboard(name: "Main",bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "image_list_active"),
            selectedImage: nil)
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "profile_active"),
            selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
