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
    
    let activitityIndicator = UIActivityIndicatorView(indicatorColor: .darkGray)
    let placeholderText = UILabel(text: "\n\nClick the '+' to add a DVD\n to your library.", textColor: .label, fontSize: 24, fontWeight: .medium, textAlignment: .center, numberOfLines: 0)
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEditButtonPressed))
    
    lazy var logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
    
    lazy var deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(handleDeleteButtonPressed))
    
    lazy var addNewDvdButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddNewDvd))
    
    
    fileprivate let cellId = "Cell"
    
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
                    navigationItem.rightBarButtonItem = addNewDvdButton
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        setUpSearchBar()
        setupCollectionView()
        setupActivityIndicatorView()
        setupPlaceholderTextView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkIfUserHasDvds()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    
    fileprivate func setUpNavBar() {
        navigationItem.rightBarButtonItem = addNewDvdButton
        navigationItem.leftBarButtonItem = editButton
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
    }
    
    
    fileprivate func setUpSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search DVDs you own..."
    }
    
    
    fileprivate func setupCollectionView() {
        collectionView.register(DvdsCell.self, forCellWithReuseIdentifier: cellId)
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
    
    
    func checkIfUserHasDvds() {
        if firebase.uid == firebase.uid {
            firebase.databaseReference.child(firebase.accountDvdsReference).child(firebase.uid ?? "").observe(.value, with: { (snapshot) in
                if !snapshot.hasChildren() {
                    self.dvdsInCollection(.no)
                }
                self.fetchUsersDvds()
            })
        }
    }
    
    
    fileprivate func fetchUsersDvds() {
        firebase.databaseReference.child(firebase.accountDvdsReference).child(firebase.uid ?? "").observe(.childAdded, with: { (snapshot) in
            
            self.myDvds.removeAll()
            self.collectionView.reloadData()
            
            firebase.databaseReference.child(firebase.dvdsReference).child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
//                print(snapshot)
//                for child in snapshot.children {
//                    if let childSnapshot = child as? DataSnapshot,
//                        let dictionary = childSnapshot.value as? [String : Any],
//                        let id = dictionary["id"] as? Int,
//                        let mediaType = dictionary["mediaType"] as? String,
//                        let title = dictionary["title"] as? String,
//                        let name = dictionary["name"] as? String,
//                        let posterPath = dictionary["posterPath"] as? String,
//                        let backdropPath = dictionary["backdropPath"] as? String {
//
//                        let dvd = SavedDvds(id: id, mediaType: mediaType, title: title, name: name, posterPath: posterPath, backdropPath: backdropPath)
//
//                        if firebase.uid == firebase.uid {
//                            self.myDvds.append(dvd)
//                            print(self.myDvds)
//                        }
//
//                    }
//                }
                
                let value = snapshot.value as? NSDictionary
                let id = value?["id"] as? Int ?? 0
                let mediaType = value?["mediaType"] as? String ?? ""
                let title = value?["title"] as? String ?? ""
                let name = value?["name"] as? String ?? ""
                let posterPath = value?["posterPath"] as? String ?? ""
                let backdropPath = value?["backdropPath"] as? String ?? ""
                
                let dvd = SavedDvds(id: id, mediaType: mediaType, title: title, name: name, posterPath: posterPath, backdropPath: backdropPath)
                
                if firebase.uid == firebase.uid {
                    self.myDvds.append(dvd)
                }
                
                self.dvdsInCollection(.yes)
            })
        })
    }
    
        
    @objc func handleEditButtonPressed() {
        editMode = editMode == .notEditing ? .isEditing : .notEditing
    }
    
    
    @objc func handleDeleteButtonPressed() {
        let dvdToDelete = "\(myDvds[index.item].title ?? "")(\(myDvds[index.item].id ?? 0))"
        firebase.databaseReference.child(firebase.accountDvdsReference).child(firebase.uid ?? "").child(dvdToDelete).removeValue()

        self.myDvds.removeAll()
        self.editMode = .notEditing
    }
    
    
   @objc fileprivate func handleAddNewDvd() {
            addNewDvdController.delegate = self
            let addNewDvdSearchController = BaseNavigationController.controller(addNewDvdController, title: "Search", searchControllerPlaceholderText: "")
            present(addNewDvdSearchController, animated: true)
        }
    
    
    @objc  func handleLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError {
            if let errorCode = AuthErrorCode(rawValue: signOutError._code) {
                self.displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
            }
        }
        
        editMode = .notEditing
        present(welcomeController, animated: true, completion: {
            self.myDvds.removeAll()
            self.collectionView.reloadData()
        })
    }
    
}




extension DvdsController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredDvds.count
        }
        
        return myDvds.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let filteredDvd: SavedDvds
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DvdsCell
        cell.dvd = myDvds[indexPath.item]
        
        if isFiltering() {
            filteredDvd = filteredDvds[indexPath.item]
        } else {
            filteredDvd = myDvds[indexPath.item]
        }
        
        cell.dvdCoverImageView.loadImageUsingUrlString(urlString: tmdb.dvdCoverImageUrl + (filteredDvd.backdropPath ?? ""))
        
        if filteredDvd.mediaType == "tv" {
            cell.dvdTitleLabel.text = filteredDvd.name
        } else {
            cell.dvdTitleLabel.text = filteredDvd.title
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // change height to 116, after the poster path is changed to backdrop path // 300 for large
        return CGSize(width: view.frame.width / 2 - 24, height: 120)
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
            deleteButton.tintColor = .systemRed
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




extension DvdsController: PassDvdDelegate {
    func passDvd(dvd: SavedDvds) {
        self.myDvds.append(dvd)
        DispatchQueue.main.async {
            self.myDvds.removeAll()
        }
    }
}




extension DvdsController: UISearchResultsUpdating {
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
        filteredDvds = myDvds.filter({(dvd : SavedDvds) -> Bool in
            
            if dvd.mediaType == "tv" {
                return dvd.name!.lowercased().contains(searchText.lowercased())
            } else {
                return dvd.title!.lowercased().contains(searchText.lowercased())
            }
        })
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    fileprivate func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}
