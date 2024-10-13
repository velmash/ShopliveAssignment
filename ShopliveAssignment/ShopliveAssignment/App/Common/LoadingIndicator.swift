//
//  LoadingIndicator.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/13/24.
//

import UIKit

class LoadingIndicator {
    static let shared = LoadingIndicator()
    private var blurView: UIVisualEffectView?
    private var indicator: UIActivityIndicatorView?
    private var isVisible = false
    
    // 블러 효과의 알파값 (0.0 ~ 1.0)
    private let blurAlpha: CGFloat = 0.5
    
    private init() {}
    
    func show() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, !self.isVisible else { return }
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                  let rootViewController = window.rootViewController else {
                return
            }
            
            self.isVisible = true
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = window.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurView.alpha = self.blurAlpha
            
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .white
            indicator.center = blurView.center
            indicator.startAnimating()
            
            // 인디케이터를 담을 컨테이너 뷰 생성
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            containerView.layer.cornerRadius = 10
            containerView.center = blurView.center
            
            containerView.addSubview(indicator)
            indicator.center = CGPoint(x: containerView.bounds.width / 2, y: containerView.bounds.height / 2)
            
            blurView.contentView.addSubview(containerView)
            
            var topViewController = rootViewController
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }
            
            topViewController.view.addSubview(blurView)
            
            self.blurView = blurView
            self.indicator = indicator
        }
    }
    
    func hide() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, self.isVisible else { return }
            
            self.isVisible = false
            UIView.animate(withDuration: 0.3, animations: {
                self.blurView?.alpha = 0
            }) { _ in
                self.blurView?.removeFromSuperview()
                self.indicator?.stopAnimating()
                self.blurView = nil
                self.indicator = nil
            }
        }
    }
}
