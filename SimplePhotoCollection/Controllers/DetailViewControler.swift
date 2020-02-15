//
//  DetailViewControler.swift
//  SimplePhotoCollection
//
//  Created by Tommy Ngo.
//  Copyright © 2020 Ngo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        ai.color = .black
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    let imageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func set(_ url: URL) {
        activityIndicator.startAnimating()
        UIImage.image(from: url) { [weak self] (image) in
            self?.imageView.image = image
            if image != nil {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor,
                         paddingTop: 0,
                         paddingLeft: 0,
                         paddingBottom: 0,
                         paddingRight: 0,
                         width: 0,
                         height: 0)
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
