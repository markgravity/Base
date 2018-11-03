//
//  Popupable.swift
//  VideoChat
//
//  Created by Mark G on 6/14/18.
//  Copyright © 2018 Mobiclix. All rights reserved.
//

import UIKit
import PopupKit

public enum PopupConfigKey: Int {
    case dimmedMaskAlpha, shouldDismissOnBackgroundTouch
}

public protocol Popupable : NSObjectProtocol {
    func show(controller: UIViewController?, interval: TimeInterval?, configs: [PopupConfigKey:Any]?)
    func dismiss()
    func setup()
    
    static func initialView(verticalMargin: CGFloat)-> Self
}

public extension Popupable where Self:UIView {
    fileprivate var popup: PopupView {
        return superview?.superview as! PopupView
    }
    
    static func initialView(verticalMargin: CGFloat = BaseConfigure.PopupVerticalMargin)-> Self {
        let view = Self()
        let nib = UINib.init(nibName: "\(self)", bundle: nil)
        let contentView = nib.instantiate(withOwner: view, options: nil).first as! UIView
        
        var frame = contentView.frame
        frame.size.width = UIScreen.main.bounds.width - (verticalMargin * 2)
        
        view.frame = frame
        view.backgroundColor = .clear
        view.addSubview(contentView)
        contentView.autoPinEdgesToSuperviewEdges()
        
        // Setup Autolayout
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: contentView.frame.height),
            NSLayoutConstraint.init(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width - (verticalMargin * 2))
        ]
        constraints[0].priority = UILayoutPriority.init(649)
        NSLayoutConstraint.activate(constraints)
        
        view.setup()
        
        return view
    }
    
    func show(controller:UIViewController? = nil, interval: TimeInterval? = nil, configs: [PopupConfigKey:Any]? = nil) {
        let popup = PopupView.init(contentView: self)
        
        // Configs
        if let configs = configs {
            for (key, value) in configs {
                switch key {
                case .dimmedMaskAlpha:
                    popup.dimmedMaskAlpha = value as! CGFloat
                    
                case .shouldDismissOnBackgroundTouch:
                    popup.shouldDismissOnBackgroundTouch = value as! Bool
                }
            }
        }
        
        // Add to container view
        var containerView: UIView = UIApplication.shared.keyWindow!
        if let controller = controller {
            containerView = controller.view
        }
        containerView.addSubview(popup)
        
        guard let interval = interval else {
            popup.show()
            return
        }
        
        popup.show(with: interval)
    }
    
    func dismiss() {
        popup.dismiss(animated: true)
    }
    
    func setup() {}
}
