//
//  ViewController.swift
//  SimplePhotoCollection
//
//  Created by Tommy Ngo.
//  Copyright © 2020 Ngo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    weak var collectionView: UICollectionView!
    
    lazy var viewModel: ImageViewModel = { [unowned self] in
        return ImageViewModel()
    }()
    
    override func loadView() {
        super.loadView()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: collectionView.topAnchor),
            self.view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
        ])
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.delegate = self
        self.collectionView.dataSource = viewModel
        self.collectionView.delegate = self
        self.collectionView.prefetchDataSource = viewModel
        self.collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: ImageViewCell.identifier)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = .white
        
        self.viewModel.fetchData(isReload: true) { [weak self] in
            self?.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
}

extension ViewController: UpdateDataDelegate {
    func addNewImages(at indexPaths: [IndexPath]) {
        self.collectionView.insertItems(at: indexPaths)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        let url = viewModel.images[indexPath.row].downloadURL
        detailViewController.set(url)
        self.show(detailViewController, sender: true)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 50 / 3
        return CGSize(width: width, height: width)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
