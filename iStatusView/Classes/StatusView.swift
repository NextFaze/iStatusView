//
//  StatusView.swift
//  NextFaze
//
//  Created by Andreas Wulf on 15/2/17.
//  Copyright © 2017 NextFaze. All rights reserved.
//

import UIKit

/**
 Status View State
 
 - hidden: status view is hidden
 - loading: status view showing loading
 - message: status view showing message (e.g. an error)
 */
public enum StatusViewState {
    case hidden
    case loading
    case message
}

public enum StatusViewError: Error {
    /// Loading View is not set, happens with no view is added for loading
    case notInitialisedCorrectly
}

extension StatusViewError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .notInitialisedCorrectly:
            return NSLocalizedString("Loading View is not set, please set it before using StatusView", comment: "error message")
        }
    }
}

@objc public class StatusView: UIView {
    
    /// Appearance proxy property for setting the title label text color
    @objc public dynamic var titleLabelTextColor: UIColor? {
        get { return self.titleLabel.textColor }
        set { self.titleLabel.textColor = newValue }
    }
    
    /// Appearance proxy property for setting the title label font
    @objc public dynamic var titleLabelFont: UIFont? {
        get { return self.titleLabel.font }
        set { self.titleLabel.font = newValue }
    }
    
    /// Appearance proxy property for setting the message label text color
    @objc public dynamic var messageLabelTextColor: UIColor? {
        get { return self.messageLabel.textColor }
        set { self.messageLabel.textColor = newValue }
    }
    
    /// Appearance proxy property for setting the message label font
    @objc public dynamic var messageLabelFont: UIFont? {
        get { return self.messageLabel.font }
        set { self.messageLabel.font = newValue }
    }
    
    
    /// State of the StatusView
    public private(set) var state = StatusViewState.hidden
    
    /// The loading view, which is shown when state is `.loading`
    public var loadingView: UIView? {
        didSet {
            guard let loadingView = self.loadingView else{
                return
            }
            
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.clipsToBounds = true
            addSubview(loadingView)

            self.addConstraint(NSLayoutConstraint(item: loadingView,
                                                  attribute: .centerX,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .centerX,
                                                  multiplier: 1.0,
                                                  constant: 0.0))
        }
    }
    
    public let button = UIButton()
    public let titleLabel = UILabel()
    public let messageLabel = UILabel()
    public let statusImageView = UIImageView()
    
    private var initial = true
    
    /// Create
    /// Use this to setup the StatusView
    ///
    /// - Parameters:
    ///   - loadingView: pass the loading view to be shown during loading state
    ///   - view: parent view to be added to
    /// - Returns: a configured StatusView
    public static func create(with loadingView: UIView? = nil, addTo view: UIView) -> StatusView {
        let statusView = StatusView()
        view.addSubview(statusView)
        statusView.loadingView = loadingView
        statusView.setup()
        return statusView
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup() {
        self.statusImageView.translatesAutoresizingMaskIntoConstraints = false
        self.statusImageView.contentMode = .scaleAspectFit
        self.addSubview(self.statusImageView)
        
        self.addConstraint(NSLayoutConstraint(item: self.statusImageView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerX,
                                              multiplier: 1.0,
                                              constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.statusImageView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1.0,
                                              constant: 40.0))
        self.addConstraint(NSLayoutConstraint(item: self.statusImageView,
                                              attribute: .trailing,
                                              relatedBy: .greaterThanOrEqual,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1.0,
                                              constant: -40.0))
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.button)
        
        self.addConstraint(NSLayoutConstraint(item: self.button,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerX,
                                              multiplier: 1.0,
                                              constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.button,
                                              attribute: .leading,
                                              relatedBy: .greaterThanOrEqual,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1.0,
                                              constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.button,
                                              attribute: .trailing,
                                              relatedBy: .greaterThanOrEqual,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1.0,
                                              constant: 0.0))
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        self.addSubview(self.titleLabel)
        
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerX,
                                              multiplier: 1.0,
                                              constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1.0,
                                              constant: 40.0))
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1.0,
                                              constant: -40.0))
        let widthConstraint = NSLayoutConstraint(item: self.titleLabel,
                                                 attribute: .width,
                                                 relatedBy: .lessThanOrEqual,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 300.0)
        widthConstraint.priority = UILayoutPriority.defaultHigh
        self.addConstraint(widthConstraint)
        
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.messageLabel.numberOfLines = 0
        self.messageLabel.textAlignment = .center
        self.addSubview(messageLabel)
        
        self.addConstraint(NSLayoutConstraint(item: self.messageLabel,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerX,
                                              multiplier: 1.0,
                                              constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.messageLabel,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1.0,
                                              constant: 40.0))
        self.addConstraint(NSLayoutConstraint(item: self.messageLabel,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1.0,
                                              constant: -40.0))
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.state == .hidden {
            self.alpha = 1.0
            self.isHidden = true
        }
    }
    
    var layoutConstraints = [NSLayoutConstraint]()
    
    /// Show or hide status view with the following paramaters, animates where appropriate
    /// If any paramater is unset, that component will not show
    /// Before use view will need to be added to a superview and layout constraints set
    ///
    /// - Parameters:
    ///   - state: to be set to
    ///   - title: text to be set as predominant text
    ///   - message: text to be set as the more detailed text
    ///   - statusImage: image shown at the top of view
    ///   - buttonImage: image shown in button, also enabling the button
    ///   - animate: true to animate the transition between states
   public func changeTo(state: StatusViewState, title: String? = nil, message: String? = nil, statusImage: UIImage? = nil, buttonImage: UIImage? = nil, animate: Bool = true ) throws {
        
        guard let loadingView = self.loadingView else {
            throw StatusViewError.notInitialisedCorrectly
        }
        
        if state == self.state && message == self.messageLabel.text && title == self.titleLabel.text {
            // No change
            return;
        }
        
        let views = [
            "image": self.statusImageView,
            "loading": loadingView,
            "title": self.titleLabel,
            "message": self.messageLabel,
            "button": self.button
            ] as [String : Any]
        
        
        let wasHidden = self.isHidden
        
        self.state = state
        
        if !self.isHidden {
            self.superview?.bringSubview(toFront: self)
        }
        
        var visibleViews = [UIView]()
        var hiddenViews = [UIView]()
        
        if state != .hidden {
            // If the state is hidden don't change contents, so that it all fades out
            
            NSLayoutConstraint.deactivate(self.layoutConstraints)
            self.layoutConstraints.removeAll()
            
            self.titleLabel.text = title
            self.messageLabel.text = message
            self.statusImageView.image = statusImage
            self.button.setImage(buttonImage, for: .normal)
            
            var layoutComponents = [String]()
            var hiddenComponents = [String]()
            
            // Always append (for animation purposes)
            if let _ = statusImage {
                layoutComponents.append("[image]-20")
                visibleViews.append(self.statusImageView)
            } else {
                hiddenComponents.append("[image]-20")
                hiddenViews.append(self.statusImageView)
            }
            
            if self.state == .loading {
                layoutComponents.append("[loading]-20")
                visibleViews.append(loadingView)
                
                self.layoutConstraints.append(NSLayoutConstraint(item: loadingView,
                                                                 attribute: .centerY,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .centerY,
                                                                 multiplier: 0.85,
                                                                 constant: 0.0))
                
            } else {
                hiddenViews.append(loadingView)
                
                self.layoutConstraints.append(NSLayoutConstraint(item: self.titleLabel,
                                                                 attribute: .centerY,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .centerY,
                                                                 multiplier: 1.0,
                                                                 constant: 0.0))
                
                if let _ = statusImage {
                    self.layoutConstraints.append(NSLayoutConstraint(item: loadingView,
                                                                     attribute: .centerY,
                                                                     relatedBy: .equal,
                                                                     toItem: self.statusImageView,
                                                                     attribute: .centerY,
                                                                     multiplier: 1.0,
                                                                     constant: 0.0))
                } else {
                    hiddenComponents.append("[loading]")
                }
            }
            
            // Title always in layout
            layoutComponents.append("[title]")
            hiddenComponents.append("[title]")
            
            if !(self.messageLabel.text ?? "").isEmpty {
                layoutComponents.append("[message]")
                visibleViews.append(self.messageLabel)
            } else {
                hiddenComponents.append("[message]")
                hiddenViews.append(self.messageLabel)
            }
            
            if let _ = buttonImage {
                layoutComponents.append("20-[button]")
                visibleViews.append(self.button)
            } else {
                hiddenComponents.append("[button]")
                hiddenViews.append(self.button)
            }
            
            self.layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=20@1000)-\(layoutComponents.joined(separator: "-"))-(>=20@1000)-|",
                options: [],
                metrics: nil,
                views: views)
            
            self.layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:\(hiddenComponents.joined(separator: "-"))",
                options: [],
                metrics: nil,
                views: views)
            NSLayoutConstraint.activate(self.layoutConstraints)
        }
        
        if initial == false || animate == false {
            UIView.animate(withDuration: 0.32, delay: 0.0, options:UIViewAnimationOptions.curveEaseOut, animations: {
                // Don't animate contents if showing/hiding
                if !wasHidden {
                    self.layoutIfNeeded()
                }
                
                if (state == .hidden) {
                    self.alpha = 0.0
                } else {
                    self.alpha = 1.0
                    self.isHidden = false
                }
                
                for view in hiddenViews {
                    view.alpha = 0.0
                }
                
                for view in visibleViews {
                    view.alpha = 1.0
                }
                
            }) { (finished) in
                if (state == .hidden) {
                    self.isHidden = true
                }
            }
        } else {
            self.layoutIfNeeded()
            
            if (state == .hidden) {
                self.alpha = 0.0
                self.isHidden = true
            } else {
                self.alpha = 1.0
                self.isHidden = false
            }
            
            for view in hiddenViews {
                view.alpha = 0.0
            }
            
            for view in visibleViews {
                view.alpha = 1.0
            }
        }
        self.initial = false
        
    }
}
