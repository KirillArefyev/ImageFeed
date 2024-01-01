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
        baseUrl: URL = defaultBaseUrl
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseUrl)!)
        request.httpMethod = httpMethod
        return request
    }
}
