//
//  Date+Extension.swift
//  ImageFeed
//
//  Created by Кирилл on 14.11.2023.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "dd MMMM yyyy"
    return formatter
}()

extension Date {
    var dateString: String { dateFormatter.string(from: self) }
}
