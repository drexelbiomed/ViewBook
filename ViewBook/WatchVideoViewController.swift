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
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
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
            let subHeadlineAttrString = NSMutableAttributedString(string: video.category, attributes: [
                .font: UIFont.preferredFont(forTextStyle: .title2),
                .foregroundColor: UIColor(red: 0.0, green: 102.0/255, blue: 153.0/255, alpha: 1.0)
                ])
            let bodyAttrString = NSMutableAttributedString(string: video.details, attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body)
                ])
            let linkAttrString = NSMutableAttributedString(string: "→ \(video.linkTitle!)", attributes: [
                .font: UIFont.preferredFont(forTextStyle: .headline),
                .foregroundColor: UIColor(red: 7.0/255, green: 41.0/255, blue: 77.0/255, alpha: 1.0)
                ])
            linkAttrString.addAttribute(.link, value: video.linkUrl!, range: NSMakeRange(0, linkAttrString.length))
            
            // init paragraph styles
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.headIndent = 0
            paragraphStyle.firstLineHeadIndent = 0
            paragraphStyle.tailIndent = 0
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .left
            paragraphStyle.paragraphSpacing = 0.5 * UIFont.preferredFont(forTextStyle: .body).lineHeight
            paragraphStyle.lineSpacing = 1.62
            
            let linkParagraphStyle = NSMutableParagraphStyle()
            linkParagraphStyle.headIndent = 20
            linkParagraphStyle.paragraphSpacing = 0.25 * UIFont.preferredFont(forTextStyle: .headline).lineHeight
            linkParagraphStyle.lineSpacing = 1.62
            linkParagraphStyle.paragraphSpacingBefore = 20
            
            linkAttrString.addAttribute(.paragraphStyle, value: linkParagraphStyle, range: NSMakeRange(0, linkAttrString.length))
            
            // prepare merge
            let content = headlineAttrString
            var end = content.length
            content.replaceCharacters(in: NSMakeRange(end, 0), with: "\n")
            content.append(subHeadlineAttrString)
            end = content.length
            content.replaceCharacters(in: NSMakeRange(end, 0), with: "\n")
            content.append(bodyAttrString)
            end = content.length
            content.replaceCharacters(in: NSMakeRange(end, 0), with: "\n")
            content.append(linkAttrString)
            end = content.length
            content.replaceCharacters(in: NSMakeRange(end, 0), with: "\n")

            // update end length
            end = content.length
            
            content.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, (end - linkAttrString.length)))

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
//                    viewForEmbeddingWebView.alpha = 0
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension WatchVideoViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.webView.isLoading == false {
            viewForEmbeddingWebView.alpha = 1
            imageView.alpha = 0
            loader.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loader.startAnimating()
    }
}
