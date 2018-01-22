//
//  PhotoRecuperationService.swift
//  PixelCity
//
//  Created by Mélodie Benmouffek on 22/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PhotoRecuperationService {
    static var instance = PhotoRecuperationService()

    var sessionManager: SessionManager

    init() {
        let configuration = URLSessionConfiguration.default
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }

    func retrieveUrls(forAnnotation annotation: DroppablePin, completionHandler: @escaping (_ success: Bool,_ urls: [String]) -> Void) {
        sessionManager.request(flickrUrl(forApiKey: apiKey, withAnnotation: annotation, addNumberOfPhotos: 40))
            .responseJSON { (response) in
                if response.result.error == nil {
                    guard let data = response.data else { return }
                    do {
                        let json = try JSON(data: data)
                        let photosDictionnary = json["photos"].dictionaryValue
                        guard let photosDictionnaryArray = photosDictionnary["photo"]?.arrayValue else { fatalError() }
                        let urlsArray = photosDictionnaryArray.map { (photo: JSON) -> String in
                            self.buildImageUrl(photo: photo)
                        }
                        completionHandler(true, urlsArray)
                    } catch let error {
                        debugPrint(error as Any)
                        completionHandler(false, [])
                    }
                } else {
                    debugPrint(response.result.error as Any)
                    completionHandler(false, [])
                }
        }
    }

    private func buildImageUrl(photo: JSON) -> String {
        guard let farm = photo["farm"].int,
            let server = photo["server"].string,
            let id = photo["id"].string,
            let secret = photo["secret"].string else { return "" }
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_h_d.jpg"
    }
}
