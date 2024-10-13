//
//  SearchViewController.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/11/24.
//

import UIKit

class SearchViewController: BaseViewController<SearchView> {
    var viewModel: SearchViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.searchBar.delegate = self
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        contentView.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 2 {
            viewModel?.searchCharacters(nameStartsWith: searchText) { [weak self] characters in
                // UI 업데이트 로직
                self?.updateUI(with: characters)
            }
        }
    }
}

extension SearchViewController {
    func updateUI(with characters: [Character]) {
        print("캐릭터들", characters)
    }
}
