//
//  ImageViewModel.swift
//  SimplePhotoCollection
//
//  Created by Tommy Ngo.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Nuke
import UIKit

protocol UpdateDataDelegate {
    func addNewImages(at indexPaths: [IndexPath])
}

class ImageViewModel: NSObject {
    let preheater = ImagePreheater()
    var imageTasks = [Int : ImageModel]()
    var images: [ImageModel] = []
    var currentPage = 0
    var limitPerPage = 30
    var isLoadAllItems = false
    
    
    var delegate: UpdateDataDelegate?
    
    func fetchData(isReload: Bool = false, completion: @escaping(() -> Void)) {
        if isReload {
            currentPage = 0
            images.removeAll()
            isLoadAllItems = false
        }
        Client.requestListImages(page: currentPage, limit: limitPerPage) { (result) in
            switch result {
            case .success(let images):
                self.images.append(contentsOf: images)
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
}

extension ImageViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.identifier, for: indexPath) as! ImageViewCell
        let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.33))
        Nuke.loadImage(with: images[indexPath.row].thumbnailURL, options: options, into: cell.imageView)
        
        if isLoadAllItems == false, indexPath.row == self.images.count - 1 {
            currentPage += 1
            Client.requestListImages(page: currentPage, limit: limitPerPage) {[weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let imgs):
                    if imgs.count < self.limitPerPage {
                        self.isLoadAllItems = true
                    }
                    self.images.append(contentsOf: imgs)
                    let indexPaths = Array(self.images.count-imgs.count...self.images.count-1).map({IndexPath(item: $0, section: 0)})
                    self.delegate?.addNewImages(at: indexPaths)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        return cell
    }
}

extension ImageViewModel: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        preheater.startPreheating(with: indexPaths.map({ (indexPath) -> URL in
            return images[indexPath.row].thumbnailURL
        }))
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        preheater.stopPreheating(with: indexPaths.map({ (indexPath) -> URL in
            return images[indexPath.row].thumbnailURL
        }))
    }
}
