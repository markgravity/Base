//
//  Popupable.swift
//  VideoChat
//
//  Created by Mark G on 6/14/18.
//  Copyright © 2018 Mobiclix. All rights reserved.
//

import UIKit
import PopupKit

public typealias PopupShowType = PopupView.ShowType
public typealias PopupDismissType = PopupView.DismissType
public typealias PopupLayoutHorizontal = PopupView.HorizontalLayout
public typealias PopupLayoutVertical = PopupView.VerticalLayout
public typealias PopupMaskType = PopupView.MaskType

public enum PopupConfigKey: Int {
    case dimmedMaskAlpha,
    shouldDismissOnBackgroundTouch,
    showType,
    dismissType,
    layoutHorizontal,
    layoutVertical,
    onDismiss,
    onShowing,
    maskType
}


public protocol Popupable : NSObjectProtocol {
    func show(controller: UIViewController?, interval: TimeInterval?, configs: [PopupConfigKey:Any]?)
//    func setOnDismiss(_ handler:@escaping (()->()))
    func dismiss()
    func setup()
    
    static func initialView(verticalMargin: CGFloat)-> Self
}

public extension Popupable where Self:UIView {
    fileprivate var popup: PopupView? {
        return superview?.superview as? PopupView
    }
    
    static func initialView(verticalMargin: CGFloat = BaseConfigure.PopupVerticalMargin)-> Self {
        let view = Self()
        let nib = UINib.init(nibName: "\(self)", bundle: nil)
        let contentView = nib.instantiate(withOwner: view, options: nil).first as! UIView
        
        var frame = contentView.frame
        frame.size.width = UIScreen.main.bounds.width - (verticalMargin * 2)
        
        // Max height
        let maxHeight = UIScreen.main.bounds.height * 10 / 12
        
        view.frame = frame
        view.backgroundColor = .clear
        view.addSubview(contentView)
        contentView.autoPinEdgesToSuperviewEdges()
        
        // Setup Autolayout
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.height),
            NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: maxHeight),
            NSLayoutConstraint.init(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.width)
        ]
        constraints[0].priority = UILayoutPriority.init(649)
        NSLayoutConstraint.activate(constraints)
        
        view.setup()
        
        return view
    }
    
    func show(controller:UIViewController? = nil, interval: TimeInterval? = nil, configs: [PopupConfigKey:Any]? = nil) {
        let popup = PopupView(contentView: self)
        var layout = PopupView.Layout(horizontal: .center, vertical: .center)

        // Configs
        if let configs = configs {
            for (key, value) in configs {
                switch key {
                case .dimmedMaskAlpha:
                    popup.dimmedMaskAlpha = value as! CGFloat

                case .shouldDismissOnBackgroundTouch:
                    popup.shouldDismissOnBackgroundTouch = value as! Bool

                case .dismissType:
                    popup.dismissType = value as! PopupDismissType

                case .showType:
                    popup.showType = value as! PopupShowType

                case .layoutHorizontal:
                    layout.horizontal = value as! PopupLayoutHorizontal

                case .layoutVertical:
                    layout.vertical = value as! PopupLayoutVertical
                    
                case .onDismiss:
                    popup.didFinishDismissingCompletion = value as! (()->())
                    
                case .onShowing:
                    popup.didFinishShowingCompletion = value as! (()->())
                    
                case .maskType:
                    popup.maskType = value as! PopupMaskType
                }
            }
        }

        // Add to container view
        var containerView: UIView!
        if let controller = controller {
            containerView = controller.view
        } else {
            // Prepare by adding to the top window.
            containerView = UIApplication.shared.keyWindow!

        }
        
        containerView.addSubview(popup)
        containerView.bringSubviewToFront(popup)
        
        guard let interval = interval else {
            popup.show(with: layout)
            return
        }

        popup.show(with: layout, duration: interval)
    }
    
    func dismiss() {
        popup?.dismiss(animated: true)
    }
    
    func setup() {}
}
