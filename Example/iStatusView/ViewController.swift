//
//  ViewController.swift
//  iStatusView
//
//  Created by awulf on 03/16/2018.
//  Copyright (c) 2018 awulf. All rights reserved.
//

import UIKit
import SVProgressHUD
import iStatusView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Force to render correctly
        let radius = self.loadingView.radius
        self.loadingView.radius = 0
        self.loadingView.radius = radius
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

