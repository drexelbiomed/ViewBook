//
//  URLConstants.swift
//  ViewBook
//
//  Created by Dave Myers on 11/12/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import Foundation

public struct URLConstants {
    private static let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    private static let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    
    private struct utm {
        static let campaign = "biomed_app"
        static let source = "biomed_app"
        static let medium = "iOS"
        static let content = versionNumber + "." + buildNumber
    }
    
    static let ga = "?utm_campaign=\(utm.campaign)&utm_source=\(utm.source)&utm_medium=\(utm.medium)&utm_content=\(utm.content)"
    
    static let videos = "https://drexel.edu/~/media/Files/biomed/videos.json"
    static let about = "https://drexel.edu/biomed/resources/faculty-and-staff/about"

    public struct news {
        static let biomed = "https://drexel.edu/biomed/news"
        static let now = "https://drexel.edu/now/biomed-news"
        static let newsblog = "https://newsblog.drexel.edu/tag/school-of-biomedical-engineering-science-and-health-systems/feed/"
    }
    
    public struct academics {
        static let undergraduate = "https://drexel.edu/biomed/resources/faculty-and-staff/undergraduate-programs"
        static let graduate = "https://drexel.edu/biomed/resources/faculty-and-staff/graduate-programs"
        static let certificate = "https://drexel.edu/biomed/resources/faculty-and-staff/certificate-programs"
    }
}
