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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func addSubviews() {
        addSubview(searchBar)
    }
    
    override func addConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
}
