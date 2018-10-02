//
//  AcademicsCell.swift
//  ViewBook
//
//  Created by Dave Myers on 10/2/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

class AcademicsCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with program: AcademicsRow) {
        let headlineAttrString = NSMutableAttributedString(string: strip(string: program.headline), attributes: [.font: UIFont.preferredFont(forTextStyle: .headline), .foregroundColor: #colorLiteral(red: 0.02727892995, green: 0.2292442918, blue: 0.4042541981, alpha: 1)])
        let summaryAttrString = NSMutableAttributedString(string: strip(string: program.summary), attributes: [
            .font: UIFont.preferredFont(forTextStyle: .body)
            ])
        let linkAttrString = NSMutableAttributedString(string: "→ Read More", attributes: [
            .font: UIFont.preferredFont(forTextStyle: .headline),
            .foregroundColor: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            ])
        linkAttrString.addAttribute(.link, value: program.link, range: NSMakeRange(0, linkAttrString.length))
        
        let attrStringArray = [headlineAttrString, summaryAttrString, linkAttrString]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 0
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.tailIndent = 0
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .left
        paragraphStyle.paragraphSpacing = 0.5 * UIFont.preferredFont(forTextStyle: .body).lineHeight
        paragraphStyle.lineSpacing = 1.62
        
        let content: NSMutableAttributedString = NSMutableAttributedString(string: "")
        var end = content.length
        for (index, attrString) in attrStringArray.enumerated() {
            content.append(attrString)
            end = content.length
            if index == (attrStringArray.count - 2) {
                content.replaceCharacters(in: NSMakeRange(end, 0), with: "\n")
            } else {
                content.replaceCharacters(in: NSMakeRange(end, 0), with: "\n")
            }
        }
        
        content.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, content.length))
        
        
        self.textView.attributedText = content
    }
    
    func strip (string: String) -> String {
        var newString = string
        newString = newString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).replacingOccurrences(of: "\t", with: "", range: nil).replacingOccurrences(of: "\n", with: "", range: nil)
        return newString
    }

}
