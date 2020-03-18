//
//  BannerView.swift
//  CustomBanner
//
//  Created by Christian Kailan (E-E) on 17.03.20.
//  Copyright © 2020 Christian Kailan (E-E). All rights reserved.
//

import UIKit

class BannerView: UIView {
    
    var viewToShow: UIViewController?
    
    var anchorToAnimate: NSLayoutConstraint?
    
    private var minLabelPadding: CGFloat = 12
    
    private let duration = 5
    
    private(set) var isDisplaying = false
    
    private var paddingTop: CGFloat
    private var paddingBottom: CGFloat
    private var paddingLeft: CGFloat
    private var paddingRight: CGFloat
    
    private var titleLable: UILabel = UILabel()
    
    private var subTitleLabel: UILabel = UILabel()
    
    private func getWidth() -> CGFloat {
        guard let viewToShow = viewToShow else { return 0 }
        return viewToShow.view.bounds.width - paddingRight - paddingLeft
    }
    
    
    init(title: String, subTitle: String, toView: UIViewController, padding: UIEdgeInsets? = nil, backgroundColor: UIColor? = nil, cornerRadius: CGFloat? = nil) {
        
        if let padding = padding {
            self.paddingTop = padding.top
            self.paddingLeft = padding.left
            self.paddingRight = padding.right
            self.paddingBottom = padding.bottom
        } else {
            self.paddingTop = 0
            self.paddingLeft = 0
            self.paddingRight = 0
            self.paddingBottom = 0
        }
        super.init(frame: .zero)

        self.viewToShow = toView
        
        if let color = backgroundColor {
            self.backgroundColor = color
        }
        
        if let radius = cornerRadius {
            self.layer.cornerRadius = radius
        }
        
        self.titleLable.text = title
        self.subTitleLabel.text = subTitle
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onTapGestureRecognizer() {
        if self.isDisplaying {
            dismiss(now: true)
        }
    }
    
    func show() {
        guard let viewToShow = viewToShow else { return }
        isDisplaying = true
        
        titleLable.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLable.numberOfLines = 0
        subTitleLabel.numberOfLines = 0
        
        viewToShow.view.addSubview(self)
        
        self.frame = CGRect(origin: CGPoint(x: paddingLeft, y: -calculateSize()), size: CGSize(width: viewToShow.view.bounds.width - paddingLeft - paddingRight, height: calculateSize()))
        
        self.addSubview(titleLable)
        titleLable.sizeToFit()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: minLabelPadding).isActive = true
        titleLable.topAnchor.constraint(equalTo: self.topAnchor, constant: minLabelPadding).isActive = true
        titleLable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -minLabelPadding).isActive = true
        self.layoutIfNeeded()
        titleLable.textColor = .white
        
        
        self.addSubview(subTitleLabel)
        subTitleLabel.sizeToFit()
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: minLabelPadding).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: minLabelPadding).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -minLabelPadding).isActive = true
        self.layoutIfNeeded()
        subTitleLabel.textColor = .white
  
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTapGestureRecognizer))
        self.addGestureRecognizer(tapGestureRecognizer)
        
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7,
        initialSpringVelocity: 1, animations: {
            self.frame = CGRect(origin: CGPoint(x: self.paddingLeft, y: self.paddingTop + self.safeArea()), size: CGSize(width: viewToShow.view.bounds.width - self.paddingLeft - self.paddingRight, height: self.calculateSize()))
        }) { (complete) in
            self.perform(#selector(self.dismiss), with: self, afterDelay: TimeInterval(self.duration))
        }
    }
    
    @objc func dismiss(now: Bool = false) {
        if !self.isDisplaying { return }
        guard let viewToShow = viewToShow else { return }
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7,
        initialSpringVelocity: 1 ,options: [.allowUserInteraction], animations: {
            self.frame = CGRect(origin: CGPoint(x: self.paddingLeft, y: -self.calculateSize()), size: CGSize(width: viewToShow.view.bounds.width - self.paddingLeft - self.paddingRight, height: self.calculateSize()))
        }) { (sucess) in
            if sucess {
                self.isDisplaying = false
                self.removeFromSuperview()
            }
        }
    }
    
    private func safeArea() -> CGFloat{
        if let height = window?.windowScene?.statusBarManager?.statusBarFrame.height {
            return height
        } else {
            return 0
        }
    }
    
    private func calculateSize() -> CGFloat {
        subTitleLabel.sizeToFit()
        titleLable.sizeToFit()
        var overallHeight = minLabelPadding * 3
        self.layoutIfNeeded()
        overallHeight += titleLable.sizeThatFits(CGSize(width: getWidth(), height: self.frame.height)).height
        overallHeight += subTitleLabel.sizeThatFits(CGSize(width: getWidth(), height: self.frame.height)).height
        return overallHeight
    }


}
