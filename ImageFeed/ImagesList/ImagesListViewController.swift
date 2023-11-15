//
//  ViewController.swift
//  ImageFeed
//
//  Created by Кирилл on 08.11.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private var tableView: UITableView!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}
