//
//  CharacterGridView.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/14/24.
//

import UIKit
import SnapKit

class CharacterGridView: UIView {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let sideInset: CGFloat = 16
            let interItemSpacing: CGFloat = 10
            
            // 전체 너비에서 좌우 패딩과 중간 간격을 뺀 후 2로 나누어 아이템 너비 계산
            let itemWidth = (UIScreen.main.bounds.width - (2 * sideInset) - interItemSpacing) / 2
            let itemHeight = itemWidth * 1.5 // 높이는 너비의 1.5배
            
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.minimumInteritemSpacing = interItemSpacing
            layout.minimumLineSpacing = 20 // 세로 간격을 좀 더 넓게
            layout.sectionInset = UIEdgeInsets(top: 10, left: sideInset, bottom: 10, right: sideInset)
        }
    }
}
