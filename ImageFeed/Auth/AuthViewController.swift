//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Кирилл on 06.12.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: AuthViewControllerDelegate?
    // MARK: - Private Properties
    private let showWebViewSegueIdentifer = "ShowWebView"
    // MARK: - Overrides Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifer {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else { 
                assertionFailure("Fatal error for prepare \(showWebViewSegueIdentifer)")
                return }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
// MARK: - Extensions
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vс: WebViewViewController) {
        dismiss(animated: true)
    }
}
