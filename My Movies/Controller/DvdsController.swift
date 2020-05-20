//
//  DvdsController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class DvdsController: BaseListController {
    
    // MARK: - views
    let activitityIndicator = UIActivityIndicatorView(indicatorColor: .darkGray)
    let placeholderText = UILabel(text: "\n\nClick the '+' to add a movie\n to your library.", textColor: .label, fontSize: 24, fontWeight: .medium, textAlignment: .center, numberOfLines: 0)
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEditButtonPressed))
        return button
    }()
    
    lazy var logoutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleSignout))
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
    var myDvds = [SavedDvds]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    var filteredDvds = [SavedDvds]()
    var timer: Timer?
    var selectedIndexPath: [IndexPath: Bool] = [:]
    var index: IndexPath!
    
    
    enum EditMode {
        case notEditing
        case isEditing
    }

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
                collectionView.allowsMultipleSelection = false
                collectionView.allowsSelection = true
            }
        }
    }
    
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        setupCollectionView()
        setupActivityIndicatorView()
        setupPlaceholderTextView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkIfUserHasMovies()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: - setup
    fileprivate func setUpNavBar() {
        navigationItem.rightBarButtonItem = addNewMovieButton
        navigationItem.leftBarButtonItem = editButton
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search movies you own..."
    }
    
    
    fileprivate func setupCollectionView() {
        collectionView.register(DvdsCell.self, forCellWithReuseIdentifier: DvdsCell.identifier)
        collectionView.register(DvdsFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DvdsFooterCell.identifier)
        collectionView.isScrollEnabled = false
        collectionView.isHidden = true
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
    enum DvdsInCollection {
        case yes, no
    }
    
    func dvdsInCollection(_ dvdsInCollection: DvdsInCollection) {
        switch dvdsInCollection {
        case .yes:
            placeholderText.isHidden = true
            activitityIndicator.isHidden = true
            activitityIndicator.stopAnimating()
            collectionView.isHidden = false
            collectionView.isScrollEnabled = true
        default:
            placeholderText.isHidden = false
            activitityIndicator.stopAnimating()
            collectionView.isHidden = true
            collectionView.isScrollEnabled = false
        }
    }
    
    
    func checkIfUserHasMovies() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if uid == uid {
            firebaseDatabaseReference.child(firebaseAccountMoviesReference).child(uid).observe(.value, with: { (snapshot) in
                if !snapshot.hasChildren() {
                    self.dvdsInCollection(.no)
                }
                self.fetchUsersMovies()
            })
        }
    }

    

    fileprivate func fetchUsersMovies() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        firebaseDatabaseReference.child(firebaseAccountMoviesReference).child(uid).observe(.childAdded, with: { (snapshot) in
            self.myDvds.removeAll()
            self.collectionView.reloadData()

            firebaseDatabaseReference.child(firebaseMoviesReference).child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                        let dict = childSnapshot.value as? [String : Any],
                        let id = dict["id"] as? Int,
                        let title = dict["title"] as? String,
                        let posterPath = dict["posterPath"] as? String,
                        let backdropPath = dict["backdropPath"] as? String
                    {
                        let movie = SavedDvds(id: id, title: title, posterPath: posterPath, backdropPath: backdropPath)
                        if uid == uid {
                            self.myDvds.append(movie)
                        }
                    }
                }
                self.dvdsInCollection(.yes)
            })
        })
    }
    
    
    
    
    
    // MARK: - @objc methods
    @objc func handleEditButtonPressed() {
        editMode = editMode == .notEditing ? .isEditing : .notEditing
        
    }
    
    
    @objc func handleDeleteButtonPressed() {
        let dvdToDelete = "\(myDvds[index.item].title ?? "")(\(myDvds[index.item].id ?? 0))"
        firebaseDatabaseReference.child(firebaseAccountMoviesReference).child(uid ?? "").child(dvdToDelete).removeValue()
        
        self.myDvds.removeAll()
        editMode = .notEditing
    }
    
    
    @objc fileprivate func handleAddNewMovie() {
        addNewDvdController.delegate = self
    
        let addNewMovieSearchController = BaseNavigationController.shared.controller(viewController: addNewDvdController, title: "Search", searchControllerText: "")
        present(addNewMovieSearchController, animated: true)
    }
    
    
    @objc func handleSignout() {
        HandleSignout().signout(completion: {
            editMode = .notEditing
            present(welcomeController, animated: true, completion: {
                self.myDvds.removeAll()
                self.collectionView.reloadData()
            })
        })
        
    }
    
}




// MARK: - footer
extension DvdsController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DvdsFooterCell.identifier, for: indexPath) as! DvdsFooterCell
        footer.label.text = "Total DVDs: \(myDvds.count)"
        return footer
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 54)
    }
}




// MARK: - collectionViewDelegate
extension DvdsController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredDvds.count
        }
        
        return myDvds.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let filteredMovie: SavedDvds
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DvdsCell.identifier, for: indexPath) as! DvdsCell
        cell.dvd = myDvds[indexPath.item]
        
        if isFiltering() {
            filteredMovie = filteredDvds[indexPath.item]
        } else {
            filteredMovie = myDvds[indexPath.item]
        }
        
        
        cell.movieCoverImageView.loadImageUsingUrlString(urlString: movieCoverImageUrl + (filteredMovie.posterPath ?? ""))
        cell.movieTitleLabel.text = filteredMovie.title
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // change height to 116, after the poster path is changed to backdrop path
        return CGSize(width: view.frame.width / 2 - 24, height: 276)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
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
            _ = myDvds[indexPath.item]
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
extension DvdsController: PassDvdDelegate {
    func passDvd(movie: SavedDvds) {
        self.myDvds.append(movie)
        DispatchQueue.main.async {
            self.myDvds.removeAll()
        }
    }
    
}




// MARK: - searchResults methods
extension DvdsController {
    override func updateSearchResults(for searchController: UISearchController) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (_) in
            self.filterContentForSearchText(searchController.searchBar.text!)
        })
    }
    
    
    fileprivate func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredDvds = myDvds.filter({(movie : SavedDvds) -> Bool in
            return movie.title!.lowercased().contains(searchText.lowercased())
        })
        collectionView.reloadData()
    }
    
}
