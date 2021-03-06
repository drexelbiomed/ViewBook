//
//  NeworkingService.swift
//  ViewBook
//
//  Created by Dave Myers on 7/16/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import Foundation
import UIKit

class NetworkingService {
    
    static let shared = NetworkingService()
    private init() {}
    
    let config = URLSessionConfiguration.default
    
    func getVideos(urlString: String, success: @escaping ([Video]) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession.init(configuration: config)
        
        session.dataTask(with: request) { (data, _, _) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let videos = try decoder.decode([Video].self, from: data)
                DispatchQueue.main.async {
                    success(videos)
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func downloadImage(fromLink url: String, success: @escaping (UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        let session = URLSession.init(configuration: config)
        session.dataTask(with: url) { (data, _, _) in
            guard let data = data,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async {
                success(image)
            }
        }.resume()
    }
}
