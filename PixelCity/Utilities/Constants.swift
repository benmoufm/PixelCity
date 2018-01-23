//
//  Constants.swift
//  PixelCity
//
//  Created by Mélodie Benmouffek on 22/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import Foundation

// API key
let apiKey = "00ca9e96edae287bbca939d8722d040a"

// Reuse Identifiers
let DROPPABLE_PIN = "droppablePin"
let PHOTO_CELL = "photoCell"
let POP_VIEW_CONTROLLER_ID = "PopViewController"

// JSON keys
let PHOTOS_KEY = "photos"
let PHOTO_KEY = "photo"
let FARM_KEY = "farm"
let SERVER_KEY = "server"
let ID_KEY = "id"
let SECRET_KEY = "secret"

// Other
let NUMBER_OF_PHOTOS = 40

func flickrUrl(forApiKey key: String, withAnnotation annotation: DroppablePin, addNumberOfPhotos number: Int) -> String {
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(key)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"
}
