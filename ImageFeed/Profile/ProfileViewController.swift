//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Кирилл on 21.11.2023.
//

import Kingfisher
import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol! { get set }
    var alertPresenter: AlertPresenterProtocol? { get set }
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    // MARK: - Public Properties
    var presenter: ProfilePresenterProtocol!
    var alertPresenter: AlertPresenterProtocol?
    // MARK: - Private Properties
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let userPhotoView: UIImageView = {
        let userPhotoView = UIImageView()
        let userStub = UIImage(named: "user_stub") ?? UIImage()
        userPhotoView.translatesAutoresizingMaskIntoConstraints = false
        userPhotoView.image = UIImage(named: "user_photo") ?? userStub
        userPhotoView.layer.cornerRadius = 35
        userPhotoView.layer.masksToBounds = true
        return userPhotoView
    }()
    
    private let userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.accessibilityIdentifier = "userNameLabel"
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.text = "Екатерина Новикова"
        userNameLabel.textColor = .ifWhite
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        return userNameLabel
    }()
    
    private let loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.accessibilityIdentifier = "loginLabel"
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = .ifGray
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        return loginLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .ifWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        return descriptionLabel
    }()
    
    private let exitButton: UIButton = {
        let exitButtonImage = UIImage(named: "exit_button") ?? UIImage()
        let exitButton = UIButton.systemButton(
            with: exitButtonImage,
            target: nil,
            action: #selector(didTapExitButton)
        )
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.tintColor = .ifRed
        exitButton.accessibilityIdentifier = "backButton"
        return exitButton
    }()
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ProfilePresenter()
        presenter.view = self
        alertPresenter = AlertPresenter(delegate: self)
        setupProfileViews()
    }
    // MARK: - Private Methods
    private func addSubviews() {
        [userPhotoView,
         userNameLabel,
         loginLabel,
         descriptionLabel,
         exitButton].forEach { view.addSubview($0) }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            userPhotoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            userPhotoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userPhotoView.heightAnchor.constraint(equalToConstant: 70),
            userPhotoView.widthAnchor.constraint(equalToConstant: 70),
            
            userNameLabel.leadingAnchor.constraint(equalTo: userPhotoView.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            userNameLabel.topAnchor.constraint(equalTo: userPhotoView.bottomAnchor, constant: 8),
            
            loginLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            loginLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            loginLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: loginLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            
            exitButton.centerYAnchor.constraint(equalTo: userPhotoView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func erasingSubviews() {
        userPhotoView.image = UIImage(named: "user_stub") ?? UIImage()
        userNameLabel.removeFromSuperview()
        loginLabel.removeFromSuperview()
        descriptionLabel.removeFromSuperview()
    }
    
    private func setupProfileViews() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        addSubviews()
        applyConstraints()
        updateAvatar()
        updateProfileDetails(presenter.profileService.profile)
    }
    
    private func updateProfileDetails(_ profile: Profile?) {
        guard let profile = profile else { return }
        self.userNameLabel.text = profile.name
        self.loginLabel.text = profile.loginName
        self.descriptionLabel.text = profile.bio
    }
    
    private func confirmationAlert() {
        let confirmAlert = ConfirmAlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            firstButtonText: "Да",
            secondButtonText: "Нет",
            firstAction: { [weak self] in
                guard let self = self else { return }
                self.presenter.logout() },
            secondAction: { [weak self] in
                guard let self = self else { return }
                self.setupProfileViews()
            })
        self.alertPresenter?.showConfirm(confirmAlert)
    }
    
    @objc private func updateAvatar() {
        guard
            let profileImageURL = presenter?.profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        userPhotoView.kf.indicatorType = .activity
        userPhotoView.kf.setImage(with: url, placeholder: UIImage(named: "user_stub"))
    }
    
    @objc private func didTapExitButton() {
        erasingSubviews()
        confirmationAlert()
    }
}
