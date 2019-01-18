//
//  MoviesController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class MoviesController: UICollectionViewController {

    private let cellId = "Cell"
    
    let searchBar = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        collectionView.backgroundColor = .white
        collectionView.register(MoviesCell.self, forCellWithReuseIdentifier: cellId)
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Movies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddNewMovie))
        navigationItem.hidesSearchBarWhenScrolling = false
        setupSearchBar()
    }
    
    func setupSearchBar() {
        searchBar.searchBar.placeholder = "Search movies you own..."
        searchBar.searchBar.tintColor = .black
//        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchBar
        definesPresentationContext = true
    }
    
    @objc func handleAddNewMovie() {
        let addNewMovieSearchController = AddNewMovieController(collectionViewLayout: UICollectionViewFlowLayout())
        let navBarController = UINavigationController(rootViewController: addNewMovieSearchController)
        present(navBarController, animated: true, completion: nil)
    }
}


extension MoviesController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MoviesCell {
            return cell
        }
        
        return UICollectionViewCell()
    }
}


extension MoviesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 24, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
