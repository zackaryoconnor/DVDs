//
//  MoviesController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class MoviesController: BaseListController {

    fileprivate let cellId = "Cell"
    
    fileprivate var myMovies = [Results]()
    
    let searchBar = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MoviesCell.self, forCellWithReuseIdentifier: cellId)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddNewMovie))
    }
    
    
    @objc fileprivate func handleAddNewMovie() {
        let addNewMovieController = AddNewMovieController()
        
        let addNewMovieSearchController = createNavController(viewController: addNewMovieController, title: "Search", searchControllerText: "Search for a movie...")
        present(addNewMovieSearchController, animated: true, completion: nil)
    }
}


extension MoviesController: UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myMovies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MoviesCell
        
        cell.movie = myMovies[indexPath.item]
        
        return cell
    }
    
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
