//
//  TableView+Extensions.swift
//  ImageFeed
//
//  Created by Кирилл on 11.11.2023.
//

import UIKit

extension ImagesListViewController: UITableViewDelegate { }

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
}
