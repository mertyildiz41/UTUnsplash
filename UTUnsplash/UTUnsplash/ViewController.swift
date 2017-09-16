//
//  ViewController.swift
//  UTUnsplash
//
//  Created by Edward MORGAN on 9/7/17.
//  Copyright © 2017 Mert YILDIZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UTUnsplashControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func testClick(_ sender: Any) {
        let splash = UTUnsplash()
        splash.delegate = self
        splash.InteritemWidth = 20
        splash.lineCount = 2
        splash.lineSpacing = 20
        splash.cellRadius = 5
        splash.apiKey = "bla bla bla" //Your api key write here
        present(splash, animated:true, completion: nil)
    }
    func UTUnsplashPickerDidCancel(_ UTUnsplashContoller: UTUnsplash) {
        UTUnsplashContoller.dismiss(animated: true, completion: nil)
    }
    func UTUnsplashPicker(_ UTUnsplashContoller: UTUnsplash, dismiss selects: [UTUnsplashObject]) {
        UTUnsplashContoller.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

