//
//  AddNewMovieController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase


protocol PassMovieDelegate {
    func passMovie(movie: SavedMovies)
}


class AddNewMovieController: BaseListController {
 
    var delegate: PassMovieDelegate?
    
    fileprivate let cellId = "Cell"
    
    fileprivate var MovieVC: MoviesController!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy fileprivate var popularMovies = [Results]()
    
    var selectedMovie: Results?
    
    var timer: Timer?
    
    let activitityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(AddNewMovieCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismissController))
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .black
        searchController.searchBar.placeholder = "Search for movie..."
        
        setupActivityIndicatorView()
        fetchPopularMovies()
    }
    
    fileprivate func setupActivityIndicatorView() {
        view.addSubview(activitityIndicator)
        activitityIndicator.isHidden = false
        activitityIndicator.startAnimating()
        activitityIndicator.centerInSuperview()
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedMovie = self.popularMovies[indexPath.item]
        self.selectedMovie = selectedMovie
        
        Database.database().reference().child("movies").observe(.value, with: { (snapshot) in

            if !snapshot.hasChild(selectedMovie.title ?? "") {
                Database.database().reference().child("movies").child(selectedMovie.title ?? "").setValue(["title": selectedMovie.title as AnyObject, "posterPath": selectedMovie.posterPath as AnyObject, "id": selectedMovie.id as AnyObject])
                
                self.popularMovies.remove(at: indexPath.row)
                collectionView.reloadData()
                
                self.delegate?.passMovie(movie: SavedMovies.init(id: selectedMovie.id!, title: selectedMovie.title ?? "", posterPath: selectedMovie.posterPath ?? ""))
                
                self.popularMovies.remove(at: indexPath.item)
                collectionView.reloadData()
                
            } else {
                let cell = AddNewMovieCell()
                cell.movieTitleLabel.textColor = .red
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
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
