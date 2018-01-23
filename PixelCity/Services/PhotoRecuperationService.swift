//
//  PhotoRecuperationService.swift
//  PixelCity
//
//  Created by Mélodie Benmouffek on 22/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit
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
        sessionManager.request(flickrUrl(forApiKey: apiKey, withAnnotation: annotation, addNumberOfPhotos: NUMBER_OF_PHOTOS))
            .responseJSON { (response) in
                if response.result.error == nil {
                    guard let data = response.data else { return }
                    do {
                        let json = try JSON(data: data)
                        let photosDictionnary = json[PHOTOS_KEY].dictionaryValue
                        guard let photosDictionnaryArray = photosDictionnary[PHOTO_KEY]?.arrayValue else { fatalError() }
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

    func retrieveImages(urls: [String], progressLabel: UILabel, completion: @escaping (_ success: Bool,_ images: [UIImage]) -> Void) {
        var imageArray = [UIImage]()
        for url in urls {
            sessionManager.request(url).responseImage(completionHandler: { (response) in
                if response.result.error == nil {
                    guard let image = response.value else { return }
                    imageArray.append(image)
                    progressLabel.text = "\(imageArray.count)/\(NUMBER_OF_PHOTOS) IMAGES DOWNLOADED"
                    if imageArray.count == urls.count {
                        completion(true, imageArray)
                    }
                } else {
                    debugPrint(response.result.error as Any)
                    completion(false, [])
                }
            })
        }
    }

    func cancelAllSessions() {
        sessionManager.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach( { $0.cancel() } )
            downloadData.forEach( { $0.cancel() } )
        }
    }

    private func buildImageUrl(photo: JSON) -> String {
        guard let farm = photo[FARM_KEY].int,
            let server = photo[SERVER_KEY].string,
            let id = photo[ID_KEY].string,
            let secret = photo[SECRET_KEY].string else { return "" }
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_h_d.jpg"
    }
}
