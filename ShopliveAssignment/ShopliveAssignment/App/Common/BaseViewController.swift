//
//  BaseViewController.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/11/24.
//

import UIKit
import SnapKit

class BaseViewController<ContentView: BaseView>: UIViewController {
    
    var contentView: ContentView {
        return view as! ContentView
    }
    
    override func loadView() {
        self.view = ContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 뷰로 사용할 부분을 TabBar 위로 고정하기 위함
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentView.snp.remakeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(contentView.tabBarHeight + contentView.bottomSafetyAreaInset)
        }
    }
}
