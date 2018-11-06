//
//  VideoCell.swift
//  ViewBook
//
//  Created by Dave Myers on 7/16/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with video: Video) {
        titleLabel.text = video.title
        
        video.image { (image) in
            self.imageView.image = image
        }
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        imageView.image = nil
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        setNeedsLayout()
//        layoutIfNeeded()
//
//        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//        print("width: \(size.width), height: \(size.height)")
//
//        var frame = layoutAttributes.frame
//        frame.size.height = ceil(size.height)
//        layoutAttributes.frame = frame
//
//        return layoutAttributes
//    }
}
