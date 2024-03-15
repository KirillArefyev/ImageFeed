//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Кирилл Арефьев on 07.02.2024.
//

import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var view: ImageFeed.WebViewViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) { }
    
    func code(from url: URL) -> String? {
        return nil
    }   
}
