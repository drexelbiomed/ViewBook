//
//  CustomTableViewHeader.swift
//  ViewBook
//
//  Created by Dave Myers on 9/11/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

class CustomTableViewHeader: UITableViewHeaderFooterView {

    static let reuseIdentifer = "CustomHeaderReuseIdentifier"
    let label = UILabel.init()
    let font = UIFont.preferredFont(forTextStyle: .headline)
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        
        let margins = contentView.layoutMarginsGuide
        label.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: margins.topAnchor, constant: 32).isActive = true
        label.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rectForText(text: String, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [.font
            : font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: (rect.size.height))
        return size
    }
}
