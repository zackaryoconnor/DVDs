//
//  AddNewMovieController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase

class AddNewMovieController: BaseListController {

    // MARK: - vars and lets
    fileprivate let activitityIndicator = UIActivityIndicatorView(indicatorColor: .darkGray)
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate let cellId = "Cell"
    fileprivate var moviesVC: MoviesController!
    fileprivate var timer: Timer?
    lazy fileprivate var popularMovies = [Results]()
    var delegate: PassMovieDelegate?
    var selectedMovie: Results?
    
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupActivityIndicatorView()
        setUpNavBar()
        fetchPopularMovies()
    }
    
    
    func checkForMovies(indexPath: IndexPath) {
        firebaseAccountMoviesReference.child(firebaseCurrentUserId ?? "").observeSingleEvent(of: .value, with: { snapshot in
            if let savedMovies = snapshot.value as? [String: AnyObject] {
                for (_, value) in savedMovies {
                    if value as? String == self.popularMovies[indexPath.item].title {
                        print("blah")
                        let vc = AddNewMovieCell()
                        vc.movieTitleLabel.textColor = .red
                        self.collectionView.cellForItem(at: indexPath)?.tintColor = .red
                    }
                }
            }
        })
        firebaseUsersReference.removeAllObservers()
    }
    
    
    // MARK: - setup
    fileprivate func setupCollectionView() {
        collectionView.register(AddNewMovieCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.allowsMultipleSelection = true
        collectionView.keyboardDismissMode = .onDrag
    }
    
    
    fileprivate func setUpNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismissController))
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .black
        searchController.searchBar.placeholder = "Search for a movie..."
    }
    
    
    fileprivate func setupActivityIndicatorView() {
        view.addSubview(activitityIndicator)
        activitityIndicator.isHidden = false
        activitityIndicator.startAnimating()
        activitityIndicator.centerInSuperview()
    }
    
    
    // MARK: - fetch data
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
    
    
    // MARK: - @objc methods
    @objc fileprivate func handleDismissController() {
        dismiss(animated: true, completion: nil)
    }
    
}




// MARK: - collectionVeiwDelegate
extension AddNewMovieController: UICollectionViewDelegateFlowLayout  {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularMovies.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AddNewMovieCell
        checkForMovies(indexPath: indexPath)
        cell.movie = self.popularMovies[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 110)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = self.popularMovies[indexPath.item]
        self.selectedMovie = selectedMovie

        
        let childRef = firebaseMoviesReference.child(selectedMovie.title ?? "")
        if firebaseCurrentUserId == firebaseCurrentUserId {
            
            childRef.observe(.value, with: { (snapshot) in
                
                if !snapshot.hasChild(selectedMovie.title ?? "") {
                    childRef.child(selectedMovie.title ?? "").setValue(["title": selectedMovie.title as AnyObject, "posterPath": selectedMovie.posterPath as AnyObject, "id": selectedMovie.id as AnyObject])
                    childRef.updateChildValues(["accountId" : firebaseCurrentUserEmail ?? ""])
                    
                    if indexPath.item > 1 {
                        self.popularMovies.remove(at: indexPath.item)
                        collectionView.reloadData()
                    }
                    
                    self.delegate?.passMovie(movie: SavedMovies.init(id: selectedMovie.id ?? 0, title: selectedMovie.title ?? "", posterPath: selectedMovie.posterPath ?? ""))
                    
                    self.searchController.searchBar.text = ""
                    self.fetchPopularMovies()
                }
                
            }) { (error) in
                print(error.localizedDescription)
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    self.displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
                }
            }
            
            guard let movieId = childRef.key else { return }
            firebaseAccountMoviesReference.child(firebaseCurrentUserId ?? "").updateChildValues([movieId : 0])
        }

    }
    
}




// MARK: - searchBarDelegate
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
                        if let errorCode = AuthErrorCode(rawValue: error._code) {
                            self.displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
                        }
                        
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
