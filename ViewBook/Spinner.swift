//
//  Spinner.swift
//  ViewBook
//
//  Created by Dave Myers on 10/5/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

public class Spinner {
    internal static var spinner: UIActivityIndicatorView?
    public static var style: UIActivityIndicatorView.Style = .whiteLarge
    public static var backgroundColor = UIColor(white: 1, alpha: 0.2)
    public static var foregroundColor = #colorLiteral(red: 0, green: 0.3796961904, blue: 0.6040052772, alpha: 1)
    
    public static func start(style: UIActivityIndicatorView.Style = style, background: UIColor = backgroundColor, foreground: UIColor = foregroundColor) {
        if spinner == nil, let window = UIApplication.shared.keyWindow {
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            spinner!.backgroundColor = background
            spinner!.style = style
            spinner?.color = foreground
            window.addSubview(spinner!)
            spinner!.startAnimating()
            print("Spinning")
        }
    }
    public static func stop() {
        if spinner != nil {
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
            if spinner == nil { print("Spinner is nil") }
        }
    }
    
    public static func update() {
        if spinner != nil {
            stop()
            start()
        }
    }
    
    
}
