//
//  PhotoRecuperationService.swift
//  PixelCity
//
//  Created by Mélodie Benmouffek on 22/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import Foundation
import Alamofire

class PhotoRecuperationService {
    static var instance = PhotoRecuperationService()

    func retrieveUrls(forAnnotation annotation: DroppablePin, completionHandler: @escaping (_ success: Bool,_ urls: [String]) -> Void) {
        var imageUrls = [String]()
        Alamofire.request(flickrUrl(forApiKey: apiKey, withAnnotation: annotation, addNumberOfPhotos: 40))
            .responseJSON { (response) in
                if response.result.error == nil {
                    guard let json = response.result.value as? Dictionary<String, AnyObject> else { return }
                    let photosDictionnary = json["photos"] as! Dictionary<String, AnyObject>
                    let photosDictionnayArray = photosDictionnary["photo"] as! [Dictionary<String, AnyObject>]
                    for photo in photosDictionnayArray {
                        let postUrl = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)_h_d.jpg"
                        imageUrls.append(postUrl)
                    }
                    completionHandler(true, imageUrls)
                } else {
                    debugPrint(response.result.error as Any)
                    completionHandler(false, [])
                }
        }
    }
}
