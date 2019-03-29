//
//  AddNewMovieController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class AddNewMovieController: BaseListController {
    
    fileprivate let cellId = "Cell"
    
    fileprivate var MovieVC: MoviesController!
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate var popularMovies = [Results]()
    
    var timer: Timer?
    
    let activitityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(AddNewMovieCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismissController))
        
        setupSearchBar()
        setupActivityIndicatorView()
        fetchPopularMovies()
    }
    
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .black
    }
    
    fileprivate func setupActivityIndicatorView() {
        view.addSubview(activitityIndicator)
        activitityIndicator.isHidden = false
        activitityIndicator.startAnimating()
        activitityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 2).isActive = true
        activitityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func fetchPopularMovies() {
        Service.shared.fetchMovies(url: moviesUrl) { (result, error) in
            self.popularMovies = result?.results ?? []
            DispatchQueue.main.async {
                self.activitityIndicator.isHidden = true
                self.activitityIndicator.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc fileprivate func handleDismissController() {
        dismiss(animated: true, completion: nil)
    }
}


extension AddNewMovieController: UICollectionViewDelegateFlowLayout  {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularMovies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AddNewMovieCell
        
        cell.movie = self.popularMovies[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension AddNewMovieController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (_) in
            
            let searchTerm = searchText
            let finalSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "%20")
            
            if searchText != "" {
                Service.shared.fetchSearchedMovie(searchTerm: finalSearchTerm) { (result, error) in
                    
                    if let error = error {
                        print("Failed to fetch apps:", error)
                        return
                    }
                    
                    self.popularMovies = result?.results ?? []
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            } else {
                self.fetchPopularMovies()
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchPopularMovies()
    }
}
