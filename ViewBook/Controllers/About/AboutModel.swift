//
//  ItemModel.swift
//  ViewBook
//
//  Created by Dave Myers on 9/12/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

class AboutRow: NSObject {
    var headline: String = "initial"
    var summary: String = "initial"
    var link: String = "initial"
    override init(){}
    init(date: String, title: String, description: String, link: String){
        self.headline = title
        self.summary = description
        self.link = link
    }
}

class AboutModel: NSObject {
    var data: [AboutRow] = []
    
    func addRow(row: AboutRow){
        data += [row]
    }
    
    func sortBy(arrayOfMatchStrings: [String], arrayOfIgnoreStrings: [String], aboutData: [AboutRow]) -> [AboutRow] {
        var sortedList = [AboutRow]()
        var skipIndicies = [Int]()
        var aboutDataCopy = aboutData
        
        for ignore in arrayOfIgnoreStrings {
            for (i, item) in aboutDataCopy.enumerated() {
                if item.headline.containsIgnoringCase(find: ignore) {
                    aboutDataCopy.remove(at: i)
                }
            }
        }
        for match in arrayOfMatchStrings {
            for (i, item) in aboutDataCopy.enumerated() {
                if item.headline.containsIgnoringCase(find: match) {
                    if !skipIndicies.contains(i) {
                        sortedList.append(item)
                        skipIndicies.append(i)
                    }
                }
            }
        }
        for skip in skipIndicies.sorted(by: >) {
            aboutDataCopy.remove(at: skip)
        }
        return sortedList + aboutDataCopy
    }
}
