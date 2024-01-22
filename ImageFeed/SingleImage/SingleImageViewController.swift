//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Кирилл on 21.11.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private weak var singleImageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    // MARK: - Properties
    var fullImageUrl: String?
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageView.image = nil
        configurateSingleImageView()
    }
    // MARK: - IB Actions
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image = singleImageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    // MARK: - Private Methods
    private func rescaleImageInScrollView(image: UIImage) {
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let minZoomScale = min(hScale, vScale)
        let maxZoomScale: CGFloat = 1.25
        scrollView.minimumZoomScale = minZoomScale
        scrollView.maximumZoomScale = maxZoomScale
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
    }
    
    private func centerImageInScrollView() {
        let visibleRectSize = scrollView.bounds.size
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func configurateSingleImageView() {
        UIBlockingProgressHUD.show()
        guard
            let fullImageUrl = fullImageUrl,
            let url = URL(string: fullImageUrl)
        else { return }
        self.singleImageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.singleImageView.image = imageResult.image
                self.rescaleImageInScrollView(image: imageResult.image)
                self.centerImageInScrollView()
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert)
        let alertActionCancel = UIAlertAction(
            title: "Не надо",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.didTapBackButton()}
        let alertActionRetry = UIAlertAction(
            title: "Повторить",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                configurateSingleImageView().self
            }
        alert.addAction(alertActionCancel)
        alert.addAction(alertActionRetry)
        self.present(alert, animated: true)
    }
}
// MARK: - Extensions
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageInScrollView()
    }
}
