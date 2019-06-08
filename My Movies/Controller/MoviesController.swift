//
//  MoviesController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MoviesController: BaseListController {
    
    let activitityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    fileprivate let cellId = "Cell"
    
    lazy var myMovies = [SavedMovies]()
    lazy var filteredMovies = [SavedMovies]()
    
    var timer: Timer?
    
    var startingFrame: CGRect?
    var movieDetailController: MovieDetailController!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MoviesCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.isUserInteractionEnabled = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddNewMovie))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
        
        searchController.searchBar.placeholder = "Search movies you own..."
        searchController.searchBar.tintColor = .black
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        }

        setupActivityIndicatorView()
        fetchMovies()
    }
    
    fileprivate func setupActivityIndicatorView() {
        view.addSubview(activitityIndicator)
        activitityIndicator.isHidden = false
        activitityIndicator.startAnimating()
        activitityIndicator.centerInSuperview()
    }
    
    fileprivate func fetchMovies() {
        self.collectionView.isHidden = true
        
        firebaseReference.observe(.value, with: { (snapshot) in
          
            var tempArray = [SavedMovies]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String : Any],
                    let id = dict["id"] as? Int,
                    let title = dict["title"] as? String,
                    let posterPath = dict["posterPath"] as? String {

                    let movie = SavedMovies(id: id, title: title, posterPath: posterPath)
                    
                    tempArray.append(movie)
                }
            }
            
            self.activitityIndicator.isHidden = true
            self.activitityIndicator.stopAnimating()
            self.myMovies = tempArray
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
            
            let moviePoster = Database.database().reference(withPath: "posterPath")
        })
    }
    
    
    @objc fileprivate func handleAddNewMovie() {
        let addNewMovieController = AddNewMovieController()
        addNewMovieController.delegate = self
        
        let addNewMovieSearchController = baseNavController(viewController: addNewMovieController, title: "Search", searchControllerText: "")
        
        present(addNewMovieSearchController, animated: true, completion: nil)
    }
    
    
    @objc fileprivate func handleLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError {
            print(signOutError)
        }

        present(SignUpController(), animated: true, completion: nil)
    }
    
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredMovies = myMovies.filter({(movie : SavedMovies) -> Bool in
            return movie.title.lowercased().contains(searchText.lowercased())
        })
        collectionView.reloadData()
    }
    
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}





extension MoviesController: UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (self.myMovies.count == 0) {
            self.collectionView.setEmptyMessage(#"""

Click the '+' to add a movie
to your collection.
"""#)
            
        } else {
            self.collectionView.restore()
        }
        
        if isFiltering() {
            return filteredMovies.count
        }
        
        return myMovies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MoviesCell
        
        cell.movie = myMovies[indexPath.item]
        
        let filteredMovie: SavedMovies
        
        if isFiltering() {
            filteredMovie = filteredMovies[indexPath.item]
        } else {
            filteredMovie = myMovies[indexPath.item]
        }
        
        
        
        cell.movieCoverImageView.loadImageUsingUrlString(urlString: movieCoverImageUrl + filteredMovie.posterPath)
        cell.movieTitleLabel.text = filteredMovie.title

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 24, height: 275)
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


extension MoviesController: PassMovieDelegate {
    func passMovie(movie: SavedMovies) {
        
        self.myMovies.append(movie)
        self.collectionView.reloadData()
    }
}


extension MoviesController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (_) in
            self.filterContentForSearchText(searchController.searchBar.text!)
        })
    }
    
}
