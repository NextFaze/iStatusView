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

    /// Appearance proxy property for setting the SF Symbol configuration used by the status image view.
    @objc public dynamic var statusImageSymbolConfiguation: UIImage.SymbolConfiguration? {
        get { self.statusImageView.preferredSymbolConfiguration }
        set { self.statusImageView.preferredSymbolConfiguration = newValue }
    }
    
    /// State of the StatusView
    public private(set) var state = StatusViewState.hidden
    
    /// The loading view, which is shown when state is `.loading`
    public var loadingView: UIView? {
        didSet {
            self.updateLoadingView(from: oldValue, to: self.loadingView)
        }
    }
    
    public let button = UIButton(configuration: .plain())
    public let titleLabel = UILabel()
    public let messageLabel = UILabel()
    public let statusImageView = UIImageView()
    
    private let contentStackView = UIStackView()
    private let loadingPlaceholderView = UIView()
    private let textStackView = UIStackView()
    
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
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.imageView?.contentMode = .scaleAspectFit
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.messageLabel.numberOfLines = 0
        self.messageLabel.textAlignment = .center
        
        self.loadingPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        self.loadingPlaceholderView.isHidden = true
        
        self.textStackView.translatesAutoresizingMaskIntoConstraints = false
        self.textStackView.axis = .vertical
        self.textStackView.alignment = .fill
        self.textStackView.spacing = 2.0
        self.textStackView.addArrangedSubview(self.titleLabel)
        self.textStackView.addArrangedSubview(self.messageLabel)
        
        self.contentStackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentStackView.axis = .vertical
        self.contentStackView.alignment = .center
        self.contentStackView.spacing = 20.0
        self.contentStackView.addArrangedSubview(self.statusImageView)
        self.contentStackView.addArrangedSubview(self.loadingPlaceholderView)
        self.contentStackView.addArrangedSubview(self.textStackView)
        self.contentStackView.addArrangedSubview(self.button)
        self.addSubview(self.contentStackView)
        
        NSLayoutConstraint.activate([
            self.contentStackView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            self.contentStackView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            self.contentStackView.topAnchor.constraint(greaterThanOrEqualTo: self.safeAreaLayoutGuide.topAnchor),
            self.contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor),
            self.contentStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.contentStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        let maxTextWidth = 300.0
        let textMaxWidthConstraint = self.textStackView.widthAnchor.constraint(lessThanOrEqualToConstant: maxTextWidth)
        textMaxWidthConstraint.priority = UILayoutPriority.required
        textMaxWidthConstraint.isActive = true
        
        // This needs to be constant width for animation to not glitch out
        let titleWidthConstraint = self.textStackView.widthAnchor.constraint(equalToConstant: maxTextWidth)
        titleWidthConstraint.priority = UILayoutPriority.defaultHigh
        titleWidthConstraint.isActive = true
        
        self.applyVisibility(for: self.state)
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.state == .hidden {
            self.alpha = 1.0
            self.isHidden = true
        }
    }
    
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
        
        guard self.loadingView != nil else {
            throw StatusViewError.notInitialisedCorrectly
        }
        
        if state == self.state && message == self.messageLabel.text && title == self.titleLabel.text {
            // No change
            return;
        }
        
        self.state = state
        
        if !self.isHidden {
            self.superview?.bringSubviewToFront(self)
        }
        
        if state != .hidden {
            // If the state is hidden don't change contents, so that it all fades out
            self.titleLabel.text = title
            self.messageLabel.text = message
            self.statusImageView.image = statusImage
            self.button.setImage(buttonImage, for: .normal)
            var configuration = self.button.configuration
            configuration?.image = buttonImage
            self.button.configuration = configuration
        }
        
        let show = state != .hidden
        let applyState = {
            self.applyVisibility(for: state)
            self.layoutIfNeeded()
            self.alpha = show ? 1.0 : 0.0
        }
        
        if animate {
            if show && self.isHidden {
                self.alpha = 0.0
                self.isHidden = false
            }
            
            UIView.animate(withDuration: 0.32, delay: 0.0, options:UIView.AnimationOptions.curveEaseOut, animations: {
                applyState()
            }) { (finished) in
                if !show && !self.isHidden {
                    self.isHidden = true
                }
            }
        } else {
            applyState()
            if self.isHidden != !show {
                self.isHidden = !show
            }
        }
        self.initial = false
        
    }
    
    private func updateLoadingView(from oldLoadingView: UIView?, to newLoadingView: UIView?) {
        if let oldLoadingView {
            self.contentStackView.removeArrangedSubview(oldLoadingView)
            oldLoadingView.removeFromSuperview()
        } else {
            self.contentStackView.removeArrangedSubview(self.loadingPlaceholderView)
            self.loadingPlaceholderView.removeFromSuperview()
        }
        
        guard let newLoadingView else {
            self.contentStackView.insertArrangedSubview(self.loadingPlaceholderView, at: 1)
            self.applyVisibility(for: self.state)
            return
        }
        
        newLoadingView.translatesAutoresizingMaskIntoConstraints = false
        newLoadingView.clipsToBounds = true
        self.contentStackView.insertArrangedSubview(newLoadingView, at: 1)
        self.applyVisibility(for: self.state)
    }
    
    private func applyVisibility(for state: StatusViewState) {
        let hasTitle = !(self.titleLabel.text ?? "").isEmpty
        let hasMessage = !(self.messageLabel.text ?? "").isEmpty
        let hasStatusImage = self.statusImageView.image != nil
        let hasButtonImage = self.button.image(for: .normal) != nil
        
        self.hideView(view: self.statusImageView, hidden: !hasStatusImage, animated: true)
        if let loadingView {
            self.hideView(view: loadingView, hidden: state != .loading, animated: true)
        }
        self.hideView(view: self.titleLabel, hidden: !hasTitle, animated: true)
        self.hideView(view: self.messageLabel, hidden: !hasMessage, animated: false)
        self.hideView(view: self.textStackView, hidden: !(hasTitle || hasMessage), animated: true)
        self.hideView(view: self.button, hidden: !hasButtonImage, animated: true)
    }
    
    private func hideView(view: UIView, hidden: Bool, animated: Bool) {
        if view.isHidden != hidden {
            view.isHidden = hidden
        }
        view.alpha = hidden ? 0.0 : 1.0
        if animated == false {
            view.layer.removeAllAnimations()
        }
    }
}
