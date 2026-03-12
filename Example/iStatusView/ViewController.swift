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
        
        // Setup view controller
        self.title = NSLocalizedString("iStatusView", comment: "title")
        self.view.backgroundColor = UIColor.red
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Change State", comment: "button title"), style: .plain, target: self, action: #selector(changeStateAction(sender:)))
        
        NSLayoutConstraint.activate([
            self.statusViewHiddenButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.statusViewHiddenButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
        
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
        
        let loadingView = self.makeLoadingView()
        
        // ## Step 3: Create the StatusView
        
        // Use the convenient create function, you must pass a loading view (even if its just a blank UIView, else nothing will work)
        self.statusView = StatusView.create(with: loadingView, addTo: self.view)
        
        // Set the size using Auto Layout constraints to fill the whole view.
        self.statusView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.statusView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.statusView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.statusView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.statusView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
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

    private func makeLoadingView() -> UIView {
        // The SwiftPM module exports SVProgressHUD itself, but not the internal ring view header.
        if let loadingViewClass = NSClassFromString("SVIndefiniteAnimatedView") as? UIView.Type {
            let loadingView = loadingViewClass.init(frame: .zero)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
            loadingView.setValue(36 as CGFloat, forKey: "radius")
            loadingView.setValue(5 as CGFloat, forKey: "strokeThickness")
            loadingView.setValue(UIColor.black, forKey: "strokeColor")

            NSLayoutConstraint.activate([
                loadingView.widthAnchor.constraint(equalToConstant: 80),
                loadingView.heightAnchor.constraint(equalToConstant: 80),
            ])

            return loadingView
        }

        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.color = UIColor.black
        loadingView.startAnimating()
        loadingView.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        return loadingView
    }
    
    // MARK: - Views
    var statusView: StatusView! = nil
    
    lazy var statusViewHiddenButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Status View is Hidden: Reload", comment: "button title"), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 4.0
        button.layer.borderWidth = 1.0
        button.contentEdgeInsets = UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(statusViewButtonPressed), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }()
}
