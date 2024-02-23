//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Кирилл Арефьев on 23.02.2024.
//

import Foundation

struct ErrorAlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}

struct ConfirmAlertModel {
    let title: String
    let message: String
    let firstButtonText: String
    let secondButtonText: String
    let firstAction: () -> Void
    let secondAction: () -> Void
}
