//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Кирилл on 08.12.2023.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vс: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    // MARK: - Public Properties
    weak var delegate: WebViewViewControllerDelegate?
    // MARK: - Private Properties
    private let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    private var estimateProgressObservation: NSKeyValueObservation?
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        didAuthorize()
        estimateProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
    }
    // MARK: - IB Actions
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    // MARK: - Private Methods
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func didAuthorize() {
        var urlComponents = URLComponents(string: unsplashAuthorizeURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: accessScope)]
        guard let url = urlComponents?.url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
// MARK: - Extensions
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
