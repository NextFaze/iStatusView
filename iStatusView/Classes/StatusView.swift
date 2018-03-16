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
 - error: status view showing error
 */
enum StatusViewState {
    case hidden
    case loading
    case error
}

@objc public class StatusView: UIView {
    
    @objc dynamic var titleLabelTextColor: UIColor? {
        get { return self.titleLabel.textColor }
        set { self.titleLabel.textColor = newValue }
    }
    
    @objc dynamic var titleLabelFont: UIFont? {
        get { return self.titleLabel.font }
        set { self.titleLabel.font = newValue }
    }
    
    @objc dynamic var messageLabelTextColor: UIColor? {
        get { return self.messageLabel.textColor }
        set { self.messageLabel.textColor = newValue }
    }
    
    @objc dynamic var messageLabelFont: UIFont? {
        get { return self.titleLabel.font }
        set { self.titleLabel.font = newValue }
    }
    
    
    private var state = StatusViewState.hidden
    
    private var loadingView: UIView
    
    public var button = UIButton()
    public var titleLabel = UILabel()
    public var messageLabel = UILabel()
    public var statusImageView = UIImageView()
    private var initial = true
    
    public static func create(with loadingView: UIView? = nil, addTo view: UIView) -> StatusView {
        let statusView = StatusView()
        statusView.setup()
        view.addSubview(statusView)
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
        self.statusImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.leading.trailing.greaterThanOrEqualTo(self).inset(40)
        }
        
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
//        self.loadingView.strokeColor = Appearance.importantTextColor;
//        self.loadingView.strokeThickness = 4
//        self.loadingView.radius = 30
        self.loadingView.clipsToBounds = true
        self.addSubview(self.loadingView)
        self.loadingView.snp.makeConstraints { (make) in
            make.width.equalTo(self.loadingView.radius * 2 + self.loadingView.strokeThickness)
            make.height.equalTo(self.loadingView.radius * 2 + self.loadingView.strokeThickness)
            make.centerX.equalTo(self)
        }
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.button)
        self.button.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.leading.trailing.greaterThanOrEqualTo(self).inset(40)
        }
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //self.titleLabel.textColor = Appearance.importantTextColor
        //self.titleLabel.font = Appearance.fontBold(ofSize: 15)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.leading.trailing.greaterThanOrEqualTo(self).inset(40)
            make.width.lessThanOrEqualTo(300).priority(900)
        }
        
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        //self.messageLabel.textColor = Appearance.regularTextColor
        //self.messageLabel.font = Appearance.fontRegular(ofSize: 12)
        self.messageLabel.numberOfLines = 0
        self.messageLabel.textAlignment = .center
        self.addSubview(messageLabel)
        self.messageLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.leading.trailing.greaterThanOrEqualTo(self).inset(40)
            make.width.lessThanOrEqualTo(300).priority(900)
        }
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.state == .hidden {
            self.alpha = 1.0
            self.isHidden = true
        }
    }
    
    var layoutConstraints = [NSLayoutConstraint]()
    
    /// The current state of the status view
    var currentState: StatusViewState {
        return self.state
    }
    
    /// Show or hide status view with the following paramaters, animates where appropriate
    /// If any paramater is unset, that component will not show
    /// Before use view will need to be added to a superview and layout constraints set
    ///
    /// - Parameters:
    ///   - state: to be set to
    ///   - title: label text
    ///   - message: label text
    ///   - statusImage: image shown at the top of view
    ///   - buttonImage: image shown in button
    ///   - animate: animate the transition
    func changeTo(state: StatusViewState, title: String? = nil, message: String? = nil, statusImage: UIImage? = nil, buttonImage: UIImage? = nil, animate: Bool = true ) {
        
        if state == self.state && message == self.messageLabel.text && title == self.titleLabel.text {
            // No change
            return;
        }
        
        let views = [
            "image": self.statusImageView,
            "loading": self.loadingView,
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
                visibleViews.append(self.loadingView)
                
                self.layoutConstraints.append(NSLayoutConstraint(item: self.loadingView,
                                                                 attribute: .centerY,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .centerY,
                                                                 multiplier: 0.85,
                                                                 constant: 0.0))
                
            } else {
                hiddenViews.append(self.loadingView)
                
                self.layoutConstraints.append(NSLayoutConstraint(item: self.titleLabel,
                                                                 attribute: .centerY,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .centerY,
                                                                 multiplier: 1.0,
                                                                 constant: 0.0))
                
                if let _ = statusImage {
                    self.layoutConstraints.append(NSLayoutConstraint(item: self.loadingView,
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
