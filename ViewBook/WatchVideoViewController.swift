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
    
    var webView: WKWebView!
    var videoId: String?
    var thisVideo: Video?
    var videoEmbedString: String?
    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: viewForEmbeddingWebView.bounds, configuration: WKWebViewConfiguration())
        webView.uiDelegate = self
        self.viewForEmbeddingWebView.addSubview(webView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let video = thisVideo {
            titleLabel.text = video.title
            videoId = video.id
            video.embed { (url) in
                self.videoEmbedString = url
                print(url)
            }
            
            if let url = URL(string: videoEmbedString!) {
                let myRequest = URLRequest(url: url)
                self.webView.load(myRequest)
                print("Got here")
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
