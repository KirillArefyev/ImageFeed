//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Кирилл on 21.11.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Private Properties
    private var userPhotoView: UIImageView!
    private var userNameLabel: UILabel?
    private var loginLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var exitButton: UIButton!
    private let userStub = UIImage(named: "user_stub")
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserPhotoView()
        addUserNameLabel()
        addLoginLabel()
        addDescriptionLabel()
        addExitButton()
    }
    // MARK: - Private Methods
    private func addUserPhotoView() {
        userPhotoView = UIImageView()
        userPhotoView.image = UIImage(named: "user_photo") ?? userStub
        userPhotoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userPhotoView)
        userPhotoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        userPhotoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        userPhotoView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userPhotoView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userPhotoView.layer.cornerRadius = 35
        userPhotoView.layer.masksToBounds = true
    }
    
    private func addUserNameLabel() {
        let userNameLabel = UILabel()
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        userNameLabel.text = "Екатерина Новикова"
        userNameLabel.textColor = .ypWhite
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        userNameLabel.leadingAnchor.constraint(equalTo: userPhotoView.leadingAnchor).isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: userPhotoView.bottomAnchor, constant: 8).isActive = true
        self.userNameLabel = userNameLabel
    }
    
    private func addLoginLabel() {
        let loginLabel = UILabel()
        guard let userNameLabel = userNameLabel else { return }
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = .ypGray
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        loginLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor).isActive = true
        loginLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        self.loginLabel = loginLabel
    }
    
    private func addDescriptionLabel() {
        let descriptionLabel = UILabel()
        guard let loginLabel = loginLabel else { return }
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: loginLabel.trailingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        self.descriptionLabel = descriptionLabel
    }
    
    private func addExitButton() {
        let exitButtonImage = UIImage(named: "exit_button")!
        let exitButton = UIButton.systemButton(
            with: exitButtonImage,
            target: self,
            action: #selector(Self.didTapExitButton)
        )
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        exitButton.tintColor = .ypRed
        exitButton.centerYAnchor.constraint(equalTo: userPhotoView.centerYAnchor).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc func didTapExitButton() {
        userPhotoView.image = userStub
        userNameLabel?.removeFromSuperview()
        userNameLabel = nil
        loginLabel?.removeFromSuperview()
        loginLabel = nil
        descriptionLabel?.removeFromSuperview()
        descriptionLabel = nil
    }
}
