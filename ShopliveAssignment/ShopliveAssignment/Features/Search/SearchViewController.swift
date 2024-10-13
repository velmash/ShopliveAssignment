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
     
        viewModel?.searchAndPrintCharacters(nameStartsWith: "iron")
    }
}

