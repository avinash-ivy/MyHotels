//
//  ImageCache.swift
//  MyHotels
//
//  Created by Banisetty Avinash on 7/12/21.
//

import Foundation
import UIKit

class ImageCache {
    
    public static let cache = ImageCache()
    //TODO: Can we use NSCache?
    private var cachedImages = Dictionary<String, UIImage>()
    
    public final func image(name: String) -> UIImage? {
        return cachedImages[name]
    }
    
    public final func saveImage(name: String, image: UIImage) {
        cachedImages[name] = image
    }
}
