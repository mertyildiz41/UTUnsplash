//
//  LoadingOverlay.swift
//  UTUnsplash
//
//  Created by Edward MORGAN on 9/8/17.
//  Copyright © 2017 Mert YILDIZ. All rights reserved.
//

import Foundation
import UIKit

public class UTUnsplashLoadingOverlay{
    
    private var overlayView : UIView!
    private var backView : UIView!
    private var activityIndicator : UIActivityIndicatorView!
    
    class var shared: UTUnsplashLoadingOverlay {
        struct Static {
            static let instance: UTUnsplashLoadingOverlay = UTUnsplashLoadingOverlay()
        }
        return Static.instance
    }
    
    init(){
        self.backView = UIView()
        self.overlayView = UIView()
        self.activityIndicator = UIActivityIndicatorView()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        backView.frame = (appDelegate.window?.frame)!
        backView.backgroundColor = UIColor.clear
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.layer.zPosition = 100
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        overlayView.addSubview(activityIndicator)
        overlayView.center = backView.center
        backView.addSubview(overlayView)
    }
    
    public func showOverlay(view:UIView) {
        view.addSubview(backView)
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        backView.removeFromSuperview()
    }
}
