//
//  ViewControllerPreviewingDelegate.swift
//  PixelCity
//
//  Created by Mélodie Benmouffek on 23/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

extension MapViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView?.indexPathForItem(at: location),
            let cell = collectionView?.cellForItem(at: indexPath),
            let popViewController = storyboard?.instantiateViewController(withIdentifier: POP_VIEW_CONTROLLER_ID) as? PopViewController else { return nil }
        popViewController.initData(forImage: imagesArray[indexPath.row])
        previewingContext.sourceRect = cell.contentView.frame
        return popViewController
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
