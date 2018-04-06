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
        
        // Setup view controller
        self.title = NSLocalizedString("iStatusView", comment: "title")
        self.view.backgroundColor = UIColor.red
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Change State", comment: "button title"), style: .plain, target: self, action: #selector(changeStateAction(sender:)))
        
        self.statusViewHiddenButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        // #######################
        // ## iStatusView Setup ##
        // #######################
        
        // ## Step 1: Style the StatusView, using appearance proxy
        StatusView.appearance().titleLabelTextColor = UIColor.black
        StatusView.appearance().titleLabelFont = UIFont.boldSystemFont(ofSize: 18)
        
        StatusView.appearance().messageLabelTextColor = UIColor(white: 0.2, alpha: 1.0)
        StatusView.appearance().messageLabelFont = UIFont.systemFont(ofSize: 16)
        StatusView.appearance().backgroundColor = UIColor.white
        
        // ## Step 2: Construct a loading view to display
        
        // Here we are using the nice looking spinner from SVProgressHUD
        // Feel free to add in any loading indicator you fancy
        let loadingView = SVIndefiniteAnimatedView()
        loadingView.radius = 36
        loadingView.strokeThickness = 5
        loadingView.strokeColor = UIColor.black
        loadingView.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.snp.makeConstraints({ (make) in
            make.width.height.equalTo(80)
        })
        
        // An example using the UIActivityIndicator
//        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
//        loadingView.color = UIColor.black
//        loadingView.startAnimating()
//        loadingView.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        // ## Step 3: Create the StatusView
        
        // Use the convenient create function, you must pass a loading view (even if its just a blank UIView, else nothing will work)
        self.statusView = StatusView.create(with: loadingView, addTo: self.view)
        
        // Set the size, in this case we are using SnapKit to set the AutoLayout constraints to fill the whole view
        self.statusView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // ## Step 4 (Optional): Listen to button presses.
        // A button appears when a button image is set when setting the state
        // Useful for a retry button, or cancel loading button
        self.statusView.button.addTarget(self, action: #selector(statusViewButtonPressed), for: .touchUpInside)
        
        // ## Step 5: Show a state
        try? self.statusView.changeTo(state: .loading,
                                      title: NSLocalizedString("Preparing App", comment: ""),
                                      message: NSLocalizedString("Choose \"Change State\" from the top left to see other states", comment: ""),
                                      statusImage: nil,
                                      buttonImage: nil,
                                      animate: false)
        
        // From here set the state to .hidden or to .message depending on the state of loading the content
    }
    
    // MARK: - Actions
    
    @objc func changeStateAction(sender: UIBarButtonItem) {
        let statesSheet = UIAlertController(title: NSLocalizedString("Choose a state to change to", comment: "action title"), message: nil, preferredStyle: .actionSheet)
        statesSheet.popoverPresentationController?.barButtonItem = sender
        
        statesSheet.addAction(UIAlertAction(title: NSLocalizedString("Set to Loading", comment: "action item"), style: .default, handler: { (_) in
            try? self.statusView.changeTo(state: .loading,
                                          title: NSLocalizedString("Loading something new", comment: ""),
                                          message: NSLocalizedString("More details here", comment: ""),
                                          statusImage: nil,
                                          buttonImage: nil,
                                          animate: false)
        }))
        
        statesSheet.addAction(UIAlertAction(title: NSLocalizedString("Set to Error", comment: "action item"), style: .default, handler: { (_) in
            try? self.statusView.changeTo(state: .message,
                                          title: NSLocalizedString("Something Went Wrong", comment: ""),
                                          message: NSLocalizedString("Choose another state to change to remove this error ", comment: ""),
                                          statusImage: #imageLiteral(resourceName: "Error"),
                                          buttonImage: #imageLiteral(resourceName: "Reload"),
                                          animate: false)
        }))
        
        statesSheet.addAction(UIAlertAction(title: NSLocalizedString("Set to Warning", comment: "action item"), style: .default, handler: { (_) in
            try? self.statusView.changeTo(state: .message,
                                          title: NSLocalizedString("Warning!", comment: ""),
                                          message: nil,
                                          statusImage: #imageLiteral(resourceName: "Warning"),
                                          buttonImage: nil,
                                          animate: false)
        }))
        
        statesSheet.addAction(UIAlertAction(title: NSLocalizedString("Set to Hidden", comment: "action item"), style: .default, handler: { (_) in
            try? self.statusView.changeTo(state: .hidden,
                                          title: nil,
                                          message: nil,
                                          statusImage: nil,
                                          buttonImage: nil,
                                          animate: false)
        }))
        
        statesSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "action item"), style: .cancel, handler: nil))
        
        self.present(statesSheet, animated: true, completion: nil)
    }
    
    @objc func statusViewButtonPressed() {
        try? self.statusView.changeTo(state: .loading,
                                      title: NSLocalizedString("Reloading...", comment: ""),
                                      message: nil,
                                      statusImage: nil,
                                      buttonImage: nil,
                                      animate: false)
    }
    
    // MARK: - Views
    var statusView: StatusView! = nil
    
    lazy var statusViewHiddenButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Status View is Hidden: Reload", comment: "button title"), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 4.0
        button.layer.borderWidth = 1.0
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(statusViewButtonPressed), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }()
}

