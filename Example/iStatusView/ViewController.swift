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
    private enum DemoSymbol {
        case error
        case reload
        case success
        case warning

        var systemName: String {
            switch self {
            case .error:
                return "xmark.circle.fill"
            case .reload:
                return "arrow.counterclockwise"
            case .success:
                return "checkmark.circle.fill"
            case .warning:
                return "exclamationmark.triangle.fill"
            }
        }

        var tintColor: UIColor {
            switch self {
            case .error:
                return .systemRed
            case .reload:
                return .systemBlue
            case .success:
                return .systemGreen
            case .warning:
                return .systemOrange
            }
        }
    }

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
        StatusView.appearance().titleLabelTextColor = .label
        StatusView.appearance().titleLabelFont = .preferredFont(forTextStyle: .title3)
        
        StatusView.appearance().messageLabelTextColor = .secondaryLabel
        StatusView.appearance().messageLabelFont = .preferredFont(forTextStyle: .subheadline)
        StatusView.appearance().backgroundColor = .systemBackground
        StatusView.appearance().statusImageSymbolConfiguation = UIImage.SymbolConfiguration(pointSize: 80)
        
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
        var configuration = self.statusView.button.configuration
        configuration?.preferredSymbolConfigurationForImage = .init(textStyle: .largeTitle)
        self.statusView.button.configuration = configuration
        
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
            self.applySymbolColors(status: nil, button: nil)
            try? self.statusView.changeTo(state: .loading,
                                          title: NSLocalizedString("Loading something new", comment: ""),
                                          message: NSLocalizedString("More details here", comment: ""),
                                          statusImage: nil,
                                          buttonImage: nil,
                                          animate: true)
        }))

        statesSheet.addAction(UIAlertAction(title: NSLocalizedString("Set to Success", comment: "action item"), style: .default, handler: { (_) in
            self.applySymbolColors(status: .success, button: nil)
            try? self.statusView.changeTo(state: .message,
                                          title: NSLocalizedString("Success", comment: ""),
                                          message: NSLocalizedString("Everything loaded correctly.", comment: ""),
                                          statusImage: self.makeSymbolImage(.success),
                                          buttonImage: nil,
                                          animate: true)
        }))
        
        statesSheet.addAction(UIAlertAction(title: NSLocalizedString("Set to Error", comment: "action item"), style: .default, handler: { (_) in
            self.applySymbolColors(status: .error, button: .reload)
            try? self.statusView.changeTo(state: .message,
                                          title: NSLocalizedString("Something Went Wrong", comment: ""),
                                          message: NSLocalizedString("Choose another state to change to remove this error ", comment: ""),
                                          statusImage: self.makeSymbolImage(.error),
                                          buttonImage: self.makeSymbolImage(.reload),
                                          animate: true)
        }))
        
        statesSheet.addAction(UIAlertAction(title: NSLocalizedString("Set to Warning", comment: "action item"), style: .default, handler: { (_) in
            self.applySymbolColors(status: .warning, button: nil)
            try? self.statusView.changeTo(state: .message,
                                          title: NSLocalizedString("Warning!", comment: ""),
                                          message: nil,
                                          statusImage: self.makeSymbolImage(.warning),
                                          buttonImage: nil,
                                          animate: true)
        }))
        
        statesSheet.addAction(UIAlertAction(title: NSLocalizedString("Set to Hidden", comment: "action item"), style: .default, handler: { (_) in
            self.applySymbolColors(status: nil, button: nil)
            try? self.statusView.changeTo(state: .hidden,
                                          title: nil,
                                          message: nil,
                                          statusImage: nil,
                                          buttonImage: nil,
                                          animate: true)
        }))
        
        statesSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "action item"), style: .cancel, handler: nil))
        
        self.present(statesSheet, animated: true, completion: nil)
    }
    
    @objc func statusViewButtonPressed() {
        self.applySymbolColors(status: nil, button: nil)
        try? self.statusView.changeTo(state: .loading,
                                      title: NSLocalizedString("Reloading...", comment: ""),
                                      message: nil,
                                      statusImage: nil,
                                      buttonImage: nil,
                                      animate: true)
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
        loadingView.color = .label
        loadingView.startAnimating()
        loadingView.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        return loadingView
    }

    private func makeSymbolImage(_ symbol: DemoSymbol) -> UIImage? {
        UIImage(systemName: symbol.systemName)
    }

    private func applySymbolColors(status: DemoSymbol?, button: DemoSymbol?) {
        self.statusView.statusImageView.tintColor = status?.tintColor
        self.statusView.button.tintColor = button?.tintColor
    }
    
    // MARK: - Views
    var statusView: StatusView! = nil
    
    lazy var statusViewHiddenButton: UIButton = {
        let button = UIButton()
        var configuration: UIButton.Configuration
        if #available(iOS 26.0, *) {
            configuration = UIButton.Configuration.prominentGlass()
        } else {
            configuration = UIButton.Configuration.borderedProminent()
            configuration.baseForegroundColor = .label
        }
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        configuration.title = String(localized: "Status View is Hidden: Reload", comment: "button title")
        button.configuration = configuration
        button.addTarget(self, action: #selector(statusViewButtonPressed), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }()
}
