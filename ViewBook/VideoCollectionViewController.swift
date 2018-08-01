//
//  VideoCollectionViewController.swift
//  ViewBook
//
//  Created by Dave Myers on 7/16/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

class VideoCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingService.shared.getVideos { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        imageCache.removeAllObjects()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if let cell = sender as? VideoCell,
            let indexPath = self.collectionView.indexPath(for: cell) {
                let vc = segue.destination as! WatchVideoViewController
                    vc.thisVideo = videos[indexPath.item]
            }
        // Pass the selected object to the new view controller.
    }
    
}
extension VideoCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as? VideoCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: videos[indexPath.item])
        
        cell.imageView.layer.cornerRadius = 8
        cell.imageView.layer.masksToBounds = true
        
        return cell
    }
}
