//
//  URLRequest+Extension.swift
//  ImageFeed
//
//  Created by Кирилл on 01.01.2024.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseUrl: URL = DefaultBaseURL
    ) -> URLRequest? {
        guard let url = URL(string: path, relativeTo: baseUrl) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
