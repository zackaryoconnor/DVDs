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
    
    // MARK: - views
    let activitityIndicator = UIActivityIndicatorView(indicatorColor: .darkGray)
    let placeholderText = UILabel(text: "\n\nClick the '+' to add a movie\n to your library.", textColor: .black, fontSize: 24, fontWeight: .medium, textAlignment: .center, numberOfLines: 0)
    let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: - vars and lets
    fileprivate let cellId = "Cell"
    var myMovies = [SavedMovies]()
    var filteredMovies = [SavedMovies]()
    var timer: Timer?
    var startingFrame: CGRect?
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        setupActivityIndicatorView()
        setupCollectionView()
        checkIfUserIsLoggedIn()
        setupPlaceholderTextView()
    }
    
    
    // MARK: - setup
    fileprivate func setUpNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddNewMovie))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogOut))
        
        navigationItem.leftBarButtonItem?.tintColor = .red
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController

        searchController.searchBar.placeholder = "Search movies you own..."
        searchController.searchBar.tintColor = .black
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
    }
    
    
    fileprivate func setupCollectionView() {
        collectionView.register(MoviesCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.isUserInteractionEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.isScrollEnabled = false
        collectionView.isHidden = true
        collectionView.keyboardDismissMode = .onDrag
    }
    
    
    fileprivate func setupActivityIndicatorView() {
        view.addSubview(activitityIndicator)
        activitityIndicator.centerInSuperview()
    }
    
    
    fileprivate func setupPlaceholderTextView() {
        view.addSubview(placeholderText)
        placeholderText.centerInSuperview(size: .init(width: view.frame.width - 32, height: 500))
        placeholderText.isHidden = true
    }
    
    
    fileprivate func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        } else {
            checkIfUserHasMovies()
            fetchUsersMovies()
        }
    }
    
    
    // MARK: - fetch data
    func checkIfUserHasMovies() {
        firebaseAccountMoviesReference.child(firebaseCurrentUserId ?? "").observe(.value, with: { (snapshot) in
            
            if !snapshot.hasChildren() {
                self.activitityIndicator.stopAnimating()
                self.collectionView.isHidden = true
                self.placeholderText.isHidden = false
            } else {
                self.placeholderText.isHidden = true
            }
            
        })
    }
    
    
    fileprivate func fetchUsersMovies() {
        firebaseAccountMoviesReference.child(firebaseCurrentUserId ?? "").observe(.childAdded, with: { (snapshot) in
            firebaseMoviesReference.child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                        let dict = childSnapshot.value as? [String : Any],
                        let id = dict["id"] as? Int,
                        let title = dict["title"] as? String,
                        let posterPath = dict["posterPath"] as? String {
                        
                        let movie = SavedMovies(id: id, title: title, posterPath: posterPath)
                        if firebaseCurrentUserId == firebaseCurrentUserId {
                            self.myMovies.append(movie)
                        }
                    }
                }
                
                self.activitityIndicator.isHidden = true
                self.activitityIndicator.stopAnimating()
                self.collectionView.isHidden = false
                self.collectionView.isScrollEnabled = true
                self.collectionView.reloadData()
            })
        })
    }
    
    
    // MARK: - @objc methods
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
            if let errorCode = AuthErrorCode(rawValue: signOutError._code) {
                self.displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
            }
        }
        present(LogInController(), animated: true)
    }
    
}




// MARK: - collectionViewDelegate
extension MoviesController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredMovies.count
        }
        
        return myMovies.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MoviesCell
        let filteredMovie: SavedMovies
        
        cell.movie = myMovies[indexPath.item]
        
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




// MARK: - PassMovieDelegate
extension MoviesController: PassMovieDelegate {
    func passMovie(movie: SavedMovies) {
        self.myMovies.append(movie)
        self.collectionView.reloadData()
    }
    
}




// MARK: - searchResults methods
extension MoviesController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (_) in
            self.filterContentForSearchText(searchController.searchBar.text!)
        })
    }
    
    
    fileprivate func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    fileprivate func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredMovies = myMovies.filter({(movie : SavedMovies) -> Bool in
            return movie.title.lowercased().contains(searchText.lowercased())
        })
        collectionView.reloadData()
    }
    
    
    fileprivate func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}
