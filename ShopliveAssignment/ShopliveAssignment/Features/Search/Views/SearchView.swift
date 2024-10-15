//
//  SearchView.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/11/24.
//

import UIKit
import Then
import SnapKit

final class SearchView: BaseView {
    lazy var searchBar = UISearchBar().then {
        $0.placeholder = "마블 영웅 이름을 입력하시오."
        $0.backgroundImage = UIImage()
        $0.backgroundColor = .clear
    }
    
    lazy var characterGridView = CharacterGridView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func addSubviews() {
        addSubview(searchBar)
        addSubview(characterGridView)
    }
    
    override func addConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(basePadding * 2)
            $0.leading.equalToSuperview().offset(basePadding * 2)
            $0.trailing.equalToSuperview().inset(basePadding * 2)
            $0.height.equalTo(50)
        }
        
        characterGridView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(basePadding * 2)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
