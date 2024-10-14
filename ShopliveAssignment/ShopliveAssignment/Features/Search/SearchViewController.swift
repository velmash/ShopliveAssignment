//
//  SearchViewController.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/11/24.
//

import UIKit
import Combine

class SearchViewController: BaseViewController<SearchView> {
    var viewModel: SearchViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.searchBar.delegate = self
        setupBindings()
        setupCharacterGrid()
    }
    
    private func setupCharacterGrid() {
        contentView.characterGridView.collectionView.delegate = self
        contentView.characterGridView.collectionView.dataSource = self
    }
    
    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        
        viewModel.$characters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.contentView.characterGridView.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showError(_ error: Error) {
        print("에러:", error.localizedDescription)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchSubject.send(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.characters.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as? CharacterCell,
              let character = viewModel?.characters[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: character)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            viewModel?.loadMoreCharacters()
        }
    }
}
