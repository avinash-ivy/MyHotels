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
    private let cachedImages = NSCache<NSString, UIImage>()
    
    public final func image(name: String) -> UIImage? {
        let convertedString = name as NSString
        return cachedImages.object(forKey: convertedString)
    }
    
    public final func saveImage(name: String, image: UIImage) {
        let convertedString = name as NSString
        cachedImages.setObject(image, forKey: convertedString)
        print("DEBUG:: cachedImage with name \(convertedString)")
    }
}
