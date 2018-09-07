//
//  VideoCollectionViewController.swift
//  ViewBook
//
//  Created by Dave Myers on 7/16/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

class VideoCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    var videos = [[Video]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingService.shared.getVideos { (videos) in
            self.videos = VideoCollection(videos: videos).videosByCategory()
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
                    vc.thisVideo = videos[indexPath.section][indexPath.item]
            }
        // Pass the selected object to the new view controller.
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        print("got here")
        
        // that -40 is because I have 20px for left and right spacing constraints for the label.
        let label:UILabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: collectionView.frame.width, height: CGFloat.greatestFiniteMagnitude)))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        //here, be sure you set the font type and size that matches the one set in the storyboard label
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.text = videos[section][0].category
        label.sizeToFit()
        // Set some extra pixels for height due to the margins of the header section.
        //This value should be the sum of the vertical spacing you set in the autolayout constraints for the label. + 20 worked for me as I have 10px for top and bottom constraints.
        return CGSize(width: collectionView.frame.width, height: label.frame.height + 20)
    }
}

extension VideoCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos[section].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as? VideoCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: videos[indexPath.section][indexPath.item])
        
        cell.imageView.layer.cornerRadius = 8
        cell.imageView.layer.masksToBounds = true
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var header: VideoCollectionHeaderView?
        
        if kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as? VideoCollectionHeaderView
            header?.headerLabel.text = videos[indexPath.section][0].category
        }
        
        return header!
    }
}
