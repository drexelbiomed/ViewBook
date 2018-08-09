//
//  WatchVideoViewController.swift
//  ViewBook
//
//  Created by Dave Myers on 7/25/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit
import WebKit

class WatchVideoViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var viewForEmbeddingWebView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailsTextView: UITextView!
    
    var thisVideo: Video?
    var videoId: String?
    var videoEmbedString: String?
    var videoImageData: UIImage?
    var webView: WKWebView!

    
    override func loadView() {
        super.loadView()
        let wkConfig = WKWebViewConfiguration()
        wkConfig.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: viewForEmbeddingWebView.bounds, configuration: wkConfig)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.viewForEmbeddingWebView.addSubview(webView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let video = thisVideo {
            // init attributed strings
            let headlineAttrString = NSMutableAttributedString(string: video.title, attributes: [
                .font: UIFont.preferredFont(forTextStyle: .title1),
                .foregroundColor: UIColor(red: 0.0, green: 102.0/255, blue: 153.0/255, alpha: 1.0)
                ])
            let bodyAttrString = NSMutableAttributedString(string: video.details, attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body)
                ])
            let linkAttrString = NSMutableAttributedString(string: video.linkTitle!, attributes: [
                .font: UIFont.preferredFont(forTextStyle: .headline),
                .foregroundColor: UIColor(red: 7.0/255, green: 41.0/255, blue: 77.0/255, alpha: 1.0),
                .backgroundColor: UIColor(red: 255.0/255, green: 198.0/255, blue: 0.0, alpha: 1.0)
                ])
            linkAttrString.addAttribute(.link, value: video.linkUrl!, range: NSMakeRange(0, (video.linkTitle?.count)!))

            // prepare merge
            let content = headlineAttrString
            var end = content.length
            content.replaceCharacters(in: NSMakeRange(end, 0), with: "\n")
            content.append(bodyAttrString)
            end = content.length
            content.replaceCharacters(in: NSMakeRange(end, 0), with: "\n")
            content.append(linkAttrString)
            
            // init paragraph style
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.headIndent = 0
            paragraphStyle.firstLineHeadIndent = 0
            paragraphStyle.tailIndent = 0
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .left
            paragraphStyle.paragraphSpacing = 15
            paragraphStyle.lineSpacing = 1.62
            
            // update end length
            end = content.length
            
            content.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, end))
            
            self.detailsTextView.attributedText = content
            
            // init image placeholder while video loads
            videoId = video.id
            video.image { (image) in
                self.imageView.image = image
            }
            // init video in webview
            video.embed { (url) in
                self.videoEmbedString = url
            }
            if let url = URL(string: videoEmbedString!) {
                let myRequest = URLRequest(url: url)
                self.webView.load(myRequest)
                if self.webView.isLoading == true {
                    viewForEmbeddingWebView.alpha = 0
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WatchVideoViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.webView.isLoading == false {
            viewForEmbeddingWebView.alpha = 1
            imageView.alpha = 0
        }
    }
}
