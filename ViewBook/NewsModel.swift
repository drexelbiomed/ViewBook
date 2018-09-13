//
//  ItemModel.swift
//  ViewBook
//
//  Created by Dave Myers on 9/12/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

class NewsRow: NSObject {
    var pubDate: String = "initial"
    var headline: String = "initial"
    var summary: String = "initial"
    var link: String = "initial"
    override init(){}
    init(date: String, title: String, description: String, link: String){
        self.pubDate = date
        self.headline = title
        self.summary = description
        self.link = link
    }
}

class NewsModel: NSObject {
    var data: [NewsRow] = []
    
    func addRow(row: NewsRow){
        data += [row]
    }
}
