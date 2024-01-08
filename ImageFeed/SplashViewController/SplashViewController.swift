//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Кирилл on 11.12.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    // MARK: - Private Properties
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    
    private let splashScreenLogo: UIImageView = {
        let logoImage = UIImageView()
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.image = UIImage(named: "Vector")
        return logoImage
    }()
    // MARK: - Overrides Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = oauth2TokenStorage.token {
            self.fetchProfile(token)
        } else {
            showAuthenticationScreen()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashView()
    }
    // MARK: - Private Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
    
    private func showAuthenticationScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: true)
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: "OK",
            style: .cancel)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            splashScreenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashScreenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupSplashView() {
        view.backgroundColor = .ifBlack
        view.addSubview(splashScreenLogo)
        applyConstraints()
    }
}
// MARK: - Extensions
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.oauth2TokenStorage.token = token
                self.fetchProfile(token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                guard let username = self.profileService.profile?.username else { return }
                self.profileImageService.fetchProfileImageURL(token, username: username) { _ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
                break
            }
        }
    }
}
