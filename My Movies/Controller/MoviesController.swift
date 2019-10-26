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
    let placeholderText = UILabel(text: "\n\nClick the '+' to add a movie\n to your library.", textColor: .label, fontSize: 24, fontWeight: .medium, textAlignment: .center, numberOfLines: 0)
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEditButtonPressed))
        return button
    }()
    
    lazy var logoutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        return button
    }()
    
    lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(handleDeleteButtonPressed))
        return button
    }()
    
    lazy var addNewMovieButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddNewMovie))
        return button
    }()
    
    
    // MARK: - vars and lets
    fileprivate let cellId = "Cell"
    var myMovies = [SavedMovies]()
    var filteredMovies = [SavedMovies]()
    var timer: Timer?
//    var startingFrame: CGRect?
//    var topConstraint: NSLayoutConstraint?
//    var leadingConstraint: NSLayoutConstraint?
//    var widthConstraint: NSLayoutConstraint?
//    var heightConstraint: NSLayoutConstraint?
    var selectedIndexPath: [IndexPath: Bool] = [:]
    var index: IndexPath!
    
    var editMode: EditMode = .notEditing {
        didSet {
            switch editMode {
            case .notEditing:
                for (key, value) in selectedIndexPath {
                    if value {
                        collectionView.deselectItem(at: key, animated: true)
                    }
                }
                
                editButton.title = "Edit"
                navigationItem.leftBarButtonItems = [editButton]
                navigationItem.rightBarButtonItem = addNewMovieButton
                collectionView.allowsMultipleSelection = false
                collectionView.allowsSelection = false
            case .isEditing:
                editButton.title = "Cancel"
                logoutButton.tintColor = .red
                navigationItem.leftBarButtonItems = [editButton, logoutButton]
                navigationItem.rightBarButtonItem = deleteButton
                navigationItem.rightBarButtonItem?.isEnabled = false
                collectionView.allowsMultipleSelection = true
                collectionView.allowsSelection = true
            }
        }
    }
    
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.reloadData()
        checkIfUserIsLoggedIn()
        setUpNavBar()
        setupActivityIndicatorView()
        setupCollectionView()
        setupPlaceholderTextView()
    }
    
    
    // MARK: - setup
    func checkIfUserIsLoggedIn() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if uid != uid {
            perform(#selector(handleLogOut), with: nil, afterDelay: 2)
        }
        checkIfUserHasMovies()
    }
    
    
    fileprivate func setUpNavBar() {
        navigationItem.rightBarButtonItem = addNewMovieButton
        navigationItem.leftBarButtonItem = editButton
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
        setUpSearchBar()
    }
    
    
    fileprivate func setUpSearchBar() {
        searchController.searchBar.placeholder = "Search movies you own..."
        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.definesPresentationContext = true
    }
    
    
    fileprivate func setupCollectionView() {
        collectionView.register(MoviesCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.isUserInteractionEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.isScrollEnabled = false
        collectionView.isHidden = true
        collectionView.keyboardDismissMode = .onDrag
        collectionView.allowsSelection = false
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
    
    
    // MARK: - fetch data
    func checkIfUserHasMovies() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        firebaseReference.child(firebaseAccountMoviesReference).child(uid).observe(.value, with: { (snapshot) in
            if !snapshot.hasChildren() {
                self.activitityIndicator.stopAnimating()
                self.collectionView.isHidden = true
                self.view.backgroundColor = .systemBackground
                self.placeholderText.isHidden = false
            } else {
                self.placeholderText.isHidden = true
                self.fetchUsersMovies()
                self.collectionView.reloadData()
            }
        })
    }
    
    
    fileprivate func fetchUsersMovies() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        firebaseReference.child(firebaseAccountMoviesReference).child(uid).observe(.childAdded, with: { (snapshot) in
            firebaseReference.child(firebaseMoviesReference).child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                        let dict = childSnapshot.value as? [String : Any],
                        let id = dict["id"] as? Int,
                        let title = dict["title"] as? String,
                        let posterPath = dict["posterPath"] as? String {
                        let movie = SavedMovies(id: id, title: title, posterPath: posterPath)
                        if uid == uid {
                            self.myMovies.append(movie)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.activitityIndicator.isHidden = true
                    self.activitityIndicator.stopAnimating()
                    self.collectionView.isHidden = false
                    self.collectionView.isScrollEnabled = true
                    self.collectionView.reloadData()
                }
                self.collectionView.reloadData()
            })
        })
    }
    
    
    // MARK: - @objc methods
    @objc func handleEditButtonPressed() {
        editMode = editMode == .notEditing ? .isEditing : .notEditing
    }
    
    
    @objc func handleDeleteButtonPressed() {
        var deleteIndexPaths: [IndexPath] = []
        for (key, value) in selectedIndexPath {
            if value {
                deleteIndexPaths.append(key)
            }
        }
        
        for index in deleteIndexPaths.sorted(by: { $0.item <= $1.item }) {
            
            // remove movie from myMovies array
            myMovies.remove(at: index.item)
            #warning("fix error with deleting movies")
            print("INDEX: \(myMovies[index.item].title)")
            
            
            // remove movie from Firebase
//            guard let uid = Auth.auth().currentUser?.uid else { return }
//            firebaseReference.child(firebaseAccountMoviesReference).child(uid).child(myMovies[index.item].title).removeValue()
        }
        
        collectionView.deleteItems(at: deleteIndexPaths)
        selectedIndexPath.removeAll()
        navigationItem.rightBarButtonItem?.isEnabled = false
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
            if let errorCode = AuthErrorCode(rawValue: signOutError._code) {
                self.displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
            }
        }
        
        self.myMovies.removeAll()
        self.filteredMovies.removeAll()
        
        editMode = .notEditing
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
        let filteredMovie: SavedMovies
                
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MoviesCell
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
        return 24
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch editMode {
        case .notEditing:
            _ = myMovies[indexPath.item]
        case .isEditing:
            navigationItem.rightBarButtonItem?.isEnabled = true
            deleteButton.tintColor = .red
            selectedIndexPath[indexPath] = true
            index = indexPath
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if editMode == .isEditing {
            navigationItem.rightBarButtonItem?.isEnabled = false
            selectedIndexPath[indexPath] = false
        }
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
