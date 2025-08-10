//
//  BaseViewController.swift
//  GIFGallert
//
//  Created by Hamzeh on 10/08/2025.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    func showLoader() {
        if view.viewWithTag(ViewTags.loader.rawValue) != nil { return }

        let loaderContainer = UIView(frame: view.bounds)
        loaderContainer.backgroundColor = UIColor(white: 0, alpha: 0.3)
        loaderContainer.tag = ViewTags.loader.rawValue

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .accent
        activityIndicator.center = loaderContainer.center
        activityIndicator.startAnimating()

        loaderContainer.addSubview(activityIndicator)
        view.addSubview(loaderContainer)
    }

    func hideLoader() {
        view.viewWithTag(ViewTags.loader.rawValue)?.removeFromSuperview()
    }
    
    func showAlert(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        hideLoader()
        present(alert, animated: true)
    }
}
