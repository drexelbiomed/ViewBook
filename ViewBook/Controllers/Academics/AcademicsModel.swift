//
//  ItemModel.swift
//  ViewBook
//
//  Created by Dave Myers on 9/12/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

class AcademicsRow: NSObject {
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

class AcademicsModel: NSObject {
    var data: [AcademicsRow] = []
    
    func addRow(row: AcademicsRow){
        data += [row]
    }
    
    func sortBy(arrayOfMatchStrings: [String], academicsData: [AcademicsRow]) -> [AcademicsRow] {
        var sortedList = [AcademicsRow]()
        var skipIndicies = [Int]()
        var academicsDataCopy = academicsData
        for match in arrayOfMatchStrings {
            for (i, item) in academicsDataCopy.enumerated() {
                if item.headline.containsIgnoringCase(find: match) {
                    if !skipIndicies.contains(i) {
                        sortedList.append(item)
                        skipIndicies.append(i)
                    }
                }
            }
        }
        for skip in skipIndicies.sorted(by: >) {
            academicsDataCopy.remove(at: skip)
        }
        return sortedList + academicsDataCopy
    }
}
