//
//  FavoriteViewController.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/11/24.
//

import UIKit
import Combine

class FavoriteViewController: BaseViewController<FavoriteView> {
    var viewModel: FavoriteViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCharacterGrid()
        setupBindings()
    }
    
    private func setupCharacterGrid() {
        contentView.characterGridView.collectionView.delegate = self
        contentView.characterGridView.collectionView.dataSource = self
    }
    
    private func setupBindings() {
        viewModel?.$favoriteCharacters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.contentView.characterGridView.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.favoriteCharacters.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as? CharacterCell,
              let character = viewModel?.favoriteCharacters[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: character, isFavorite: true)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let character = viewModel?.favoriteCharacters[indexPath.item] else { return }
        
        viewModel?.toggleFavorite(for: character)
    }
}
