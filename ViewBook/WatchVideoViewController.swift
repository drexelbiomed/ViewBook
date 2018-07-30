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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewForEmbeddingWebView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
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
            titleLabel.text = video.title
            videoId = video.id
            video.image { (image) in
                self.imageView.image = image
            }
            
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
