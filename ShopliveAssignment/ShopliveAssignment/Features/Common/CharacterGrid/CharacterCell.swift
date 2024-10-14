//
//  CharacterCell.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/14/24.
//

import UIKit
import SnapKit
import Then

class CharacterCell: UICollectionViewCell {
    private let baseCellPadding: CGFloat = 8
    static let reuseIdentifier = "CharacterCell"
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let nameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.cornerRadius = baseCellPadding
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(baseCellPadding)
            $0.trailing.equalToSuperview().inset(baseCellPadding)
            $0.height.equalTo(imageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(baseCellPadding)
            $0.leading.equalToSuperview().offset(baseCellPadding)
            $0.trailing.equalToSuperview().inset(baseCellPadding)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        
        if let url = URL(string: "\(character.thumbnail.path).\(character.thumbnail.thumbnailExtension)") {
            print("HIHI", url)
            self.imageView.loadImage(from: url)
        }
    }
}
