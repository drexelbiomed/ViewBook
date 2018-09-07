//
//  VideoTableViewCell.swift
//  ViewBook
//
//  Created by Dave Myers on 9/7/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell, UICollectionViewDataSource  {
    @IBOutlet weak var videoCollectionView: UICollectionView!
    var videos: [[Video]] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        videoCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
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
}
