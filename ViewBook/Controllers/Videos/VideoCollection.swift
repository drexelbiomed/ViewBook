//
//  VideoCollection.swift
//  ViewBook
//
//  Created by Dave Myers on 9/6/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import Foundation

struct VideoCollection {
    var videos: [Video]
    
    private func categories() -> [String] {
        var categories: [String] = []
        for vid in videos {
            if !categories.contains(vid.category) {
                categories.append(vid.category)
            }
        }
        return categories
    }
    
    func videosByCategory() -> [[Video]] {
        let list = categories()
        var result: [[Video]] = []
        for cat in list {
            let videosInCategory = videos.filter { $0.category == cat }
            result.append(videosInCategory)
        }
        return result
    }
    
    func videosByCategory(matching: String) -> [Video] {
        return videos.filter { $0.category == matching }
    }
}
