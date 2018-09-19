//
//  NewsCellTableViewCell.swift
//  ViewBook
//
//  Created by Dave Myers on 9/12/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with news: NewsRow) {
        let headlineAttrString = NSMutableAttributedString(string: strip(string: news.headline), attributes: [.font: UIFont.preferredFont(forTextStyle: .headline), .foregroundColor: #colorLiteral(red: 0.02727892995, green: 0.2292442918, blue: 0.4042541981, alpha: 1)])
        let pubDateAttrString = NSMutableAttributedString(string: news.pubDate, attributes: [
            .font: UIFont.preferredFont(forTextStyle: .caption1),
            .foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            ])
        let summaryAttrString = NSMutableAttributedString(string: strip(string: news.summary), attributes: [
            .font: UIFont.preferredFont(forTextStyle: .body)
            ])
        let linkAttrString = NSMutableAttributedString(string: "→ Read More", attributes: [
            .font: UIFont.preferredFont(forTextStyle: .headline),
            .foregroundColor: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            ])
        linkAttrString.addAttribute(.link, value: news.link, range: NSMakeRange(0, linkAttrString.length))
        
        let attrStringArray = [pubDateAttrString, headlineAttrString, summaryAttrString, linkAttrString]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 0
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.tailIndent = 0
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .left
        paragraphStyle.paragraphSpacing = 1.125 * UIFont.preferredFont(forTextStyle: .body).lineHeight
        paragraphStyle.lineSpacing = 1.62
        
        let content: NSMutableAttributedString = NSMutableAttributedString(string: "")
        var end = content.length
        for (index, attrString) in attrStringArray.enumerated() {
            content.append(attrString)
            end = content.length
            if index == (attrStringArray.count - 2) {
                content.replaceCharacters(in: NSMakeRange(end, 0), with: "\n\n")
            } else {
              content.replaceCharacters(in: NSMakeRange(end, 0), with: "\n")
            }
        }
        
        self.textView.attributedText = content
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func strip (string: String) -> String {
        return string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

}
