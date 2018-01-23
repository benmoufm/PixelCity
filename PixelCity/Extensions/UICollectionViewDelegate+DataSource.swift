//
//  UICollectionViewDelegate+DataSource.swift
//  PixelCity
//
//  Created by Mélodie Benmouffek on 22/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PHOTO_CELL, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        let imageView = UIImageView(image: imagesArray[indexPath.row])
        cell.addSubview(imageView)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let popViewController = storyboard?.instantiateViewController(withIdentifier: POP_VIEW_CONTROLLER_ID) as? PopViewController else { return }
        popViewController.initData(forImage: imagesArray[indexPath.row])
        present(popViewController, animated: true, completion: nil)
    }
}
