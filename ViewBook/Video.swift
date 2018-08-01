//
//  Video.swift
//  ViewBook
//
//  Created by Dave Myers on 7/16/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import Foundation
import UIKit

struct Video: Codable {
    let title: String
    let id: String
    let details: String

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case id = "id"
        case details = "details"
    }
    
    func image(completion: @escaping (UIImage) -> Void) {
        let imgUrl: String
        imgUrl = "https://img.youtube.com/vi/\(self.id)/mqdefault.jpg"
        
        if let image = imageCache.image(forKey: id) {
            completion(image)
        } else {
            NetworkingService.shared.downloadImage(fromLink: imgUrl) { (image) in
                imageCache.add(image, forKey: self.id)
                completion(image)
            }
        }
    }
    
    func embed(completion: @escaping (String) -> Void) {
        let embedUrl: String
        embedUrl = "https://www.youtube.com/embed/\(self.id)?playsinline=1&showinfo=0&rel=0"
        completion(embedUrl)
    }
    
    
}
