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
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Force to render correctly
        try? self.statusView.changeTo(state: .loading,
                                      title: NSLocalizedString("Preparing App", comment: ""),
                                      message: NSLocalizedString("More details here", comment: ""),
                                      statusImage: nil,
                                      buttonImage: nil,
                                      animate: false)
        
    }
    
    lazy var statusView: StatusView = {
        let loadingView = SVProgressAnimatedView(frame: CGRect(x: 0, y: 0, width: 60.0, height: 60.0))
        loadingView.radius = 0
        loadingView.radius = 50
        loadingView.snp.makeConstraints({ (make) in
            make.width.height.equalTo(60.0)
        })
        
        let statusView = StatusView.create(with: loadingView, addTo: self.view)
        self.view.addSubview(statusView)
        statusView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return statusView
    }()
}

