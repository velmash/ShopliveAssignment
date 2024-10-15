//
//  FavoriteViews.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/11/24.
//

import UIKit
import SnapKit

final class FavoriteView: BaseView {
    lazy var characterGridView = CharacterGridView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func addSubviews() {
        addSubview(characterGridView)
    }
    
    override func addConstraints() {
        characterGridView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(basePadding * 2)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
