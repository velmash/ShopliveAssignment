//
//  BaseView.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/11/24.
//

import UIKit

class BaseView: UIView {
    let deviceHeight = UIScreen.main.bounds.height
    let topSafetyAreaInset = (UIApplication.shared.connectedScenes.first as! UIWindowScene).windows.first!.safeAreaInsets.top
    let bottomSafetyAreaInset = (UIApplication.shared.connectedScenes.first as! UIWindowScene).windows.first!.safeAreaInsets.bottom
    let tabBarHeight: CGFloat = 48
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        self.backgroundColor = .white
        
        addSubviews()
        addConstraints()
    }

    func addSubviews() { }
    func addConstraints() { }
}
