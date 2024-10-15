//
//  MainTabBarController.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/11/24.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .white
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let searchVC = SearchViewController()
        searchVC.viewModel = SearchViewModel()
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let favoriteVC = FavoriteViewController()
        favoriteVC.viewModel = FavoriteViewModel()
        favoriteVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        viewControllers = [searchVC, favoriteVC]
    }
}
