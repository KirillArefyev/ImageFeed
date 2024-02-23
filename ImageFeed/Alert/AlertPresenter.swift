//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Кирилл Арефьев on 23.02.2024.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol {
    func showError(_ alert: ErrorAlertModel)
    func showConfirm(_ alert: ConfirmAlertModel)
}

final class AlertPresenter: AlertPresenterProtocol {
    private weak var delegate: UIViewController?
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    func showError(_ error: ErrorAlertModel) {
        let alert = UIAlertController(
            title: error.title,
            message: error.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "errorAlert"
        let alertAction = UIAlertAction(
            title: error.buttonText,
            style: .cancel,
            handler: nil)
        alert.addAction(alertAction)
        delegate?.present(alert, animated: true)
    }
    
    func showConfirm(_ confirmation: ConfirmAlertModel) {
        let alert = UIAlertController(
            title: confirmation.title,
            message: confirmation.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "confirmationAlert"
        let alertFirstAction = UIAlertAction(
            title: confirmation.firstButtonText,
            style: .default,
            handler: { _ in
                confirmation.firstAction()
            })
        let alertSecondAction = UIAlertAction(
            title: confirmation.secondButtonText,
            style: .default,
            handler: { _ in
                confirmation.secondAction()
            })
        alert.addAction(alertFirstAction)
        alert.addAction(alertSecondAction)
        delegate?.present(alert, animated: true)
    }
}
