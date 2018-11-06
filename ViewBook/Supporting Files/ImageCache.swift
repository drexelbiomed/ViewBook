//
//  ImageCache.swift
//  ViewBook
//
//  Created by Dave Myers on 7/24/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

let imageCache = ImageCache()

class ImageCache: NSCache<AnyObject, AnyObject> {
    func add(_ image: UIImage, forKey key: String) {
        setObject(image, forKey: key as AnyObject)
    }
    
    func image(forKey key: String) -> UIImage? {
        guard let image = object(forKey: key as AnyObject) as? UIImage else { return nil }
        return image
    }
    
}
