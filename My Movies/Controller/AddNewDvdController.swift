//
//  AddNewMovieController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//
import UIKit
import Firebase

class AddNewDvdController: BaseListController {
    
    // MARK: - vars and lets
    fileprivate let noConnectionLabel = UILabel(text: "", textColor: .label, fontSize: 17, fontWeight: .regular, textAlignment: .center, numberOfLines: 0)
    fileprivate let activitityIndicator = UIActivityIndicatorView(indicatorColor: .systemBackground)
    
    let searchController = UISearchController(searchResultsController: nil)
    fileprivate let cellId = "Cell"
    fileprivate var moviesVC: DvdsController!
    fileprivate var timer: Timer?
    lazy fileprivate var popularMovies = [Results]()
    var delegate: PassDvdDelegate?
    var selectedMovie: Results?
    
    fileprivate let headerCellId = "headerCellId"
    
    
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupActivityIndicatorView()
        setUpNavBar()
        fetchPopularMovies()
        checkForConnection()
    }
    
    
    // MARK: - setup
    fileprivate func setupCollectionView() {
        collectionView.register(AddNewDvdCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.allowsMultipleSelection = true
    
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
    }
    
    
    fileprivate func setUpNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismissController))
        navigationItem.searchController = self.searchController
        
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a DVD..."
    }
    
    
    fileprivate func setupActivityIndicatorView() {
        view.addSubview(activitityIndicator)
        activitityIndicator.isHidden = false
        activitityIndicator.startAnimating()
        activitityIndicator.centerInSuperview()
    }
    
    
    
    
    // MARK: - check for data
    func checkForMovies(indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        firebaseDatabaseReference.child(firebaseAccountMoviesReference).child(uid).observeSingleEvent(of: .value, with: { snapshot in
            
            if let savedMovies = snapshot.value as? [String: AnyObject] {
                for (key, _) in savedMovies {
                    if key == "\(self.popularMovies[indexPath.item].title ?? "")(\(self.popularMovies[indexPath.item].id ?? 0))" {
                        self.collectionView.cellForItem(at: indexPath)?.isSelected = true
                    }
                }
            }
        })
    }
    
    
    fileprivate func checkForConnection() {
        firebaseCheckForConnectionReference.observe(.value) { (snapshot) in
            if let connected = snapshot.value as? Bool, connected {
                self.collectionView.isHidden = false
                self.noConnectionLabel.isHidden = true
                
                self.searchController.searchBar.isHidden = false
                self.navigationItem.title = "Search"
            } else {
                
                self.collectionView.isHidden = true
                self.view.backgroundColor = .systemBackground
                
                let attributedString = NSMutableAttributedString(string: "Cannot connect to the Internet.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 36)])
                let normalString = NSMutableAttributedString(string: "\n\nYou must connect to WI-Fi or cellular data network to access the search feature.")
                attributedString.append(normalString)
                
                self.view.addSubview(self.noConnectionLabel)
                self.noConnectionLabel.attributedText = attributedString
                self.noConnectionLabel.isHidden = false
                self.noConnectionLabel.fillSuperview(padding: .init(top: padding, left: padding, bottom: padding, right: padding))
                
                self.searchController.searchBar.isHidden = true
                self.navigationItem.title = ""
            }
        }
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
extension AddNewDvdController: UICollectionViewDelegateFlowLayout  {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularMovies.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        checkForMovies(indexPath: indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AddNewDvdCell
        cell.movie = self.popularMovies[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 112)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: inset, bottom: inset, right: inset)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedDvd = self.popularMovies[indexPath.item]
        self.selectedMovie = selectedDvd
        
        let childRef = firebaseDatabaseReference.child(firebaseMoviesReference).child("\(selectedDvd.title ?? "")(\(selectedDvd.id ?? 0))")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if uid == uid {
            childRef.observe(.value, with: { (snapshot) in
                
                if !snapshot.hasChild("\(selectedDvd.id ?? 0)") {
                    childRef.child(selectedDvd.title ?? "").setValue(["title": selectedDvd.title as AnyObject,
                                                                      "posterPath": selectedDvd.posterPath as AnyObject,
                                                                      "backdropPath": selectedDvd.backdropPath as AnyObject,
                                                                      "id": selectedDvd.id as AnyObject])
                    
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    guard let movieId = childRef.key else { return }
                    firebaseDatabaseReference.child(firebaseAccountMoviesReference).child(uid).updateChildValues([movieId : 0])
                    
                    if indexPath.item > 1 {
                        self.popularMovies.remove(at: indexPath.item)
                        collectionView.reloadData()
                    }
                    
                    self.delegate?.passDvd(movie: SavedDvds.init(id: selectedDvd.id ?? 0, title: selectedDvd.title ?? "", posterPath: selectedDvd.posterPath  ?? "", backdropPath: selectedDvd.backdropPath ?? ""))
                    
                    self.searchController.searchBar.text = ""
                    self.fetchPopularMovies()
                }
                
            }) { (error) in
                print(error.localizedDescription)
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    self.displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
                }
            }
            
            
        }
        
    }
    
    
    
    
    
//    header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId, for: indexPath)
        header.backgroundColor = .secondarySystemBackground
        let label = UILabel(text: "Unfortunately you can not add the TV shows you own on DVD just yet. ☹️", textColor: .label, fontSize: 17, fontWeight: .regular, textAlignment: .left, numberOfLines: 0)
        
        header.addSubview(label)
        let inset: CGFloat = 16
        label.fillSuperview(padding: .init(top: inset, left: inset, bottom: inset, right: inset))
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
    
}




// MARK: - searchBarDelegate
extension AddNewDvdController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (_) in
            
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            
            let searchTerm = searchText
            let finalSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "%20")
            
            if searchText != "" {
                Service.shared.fetchSearchedMovie(searchTerm: finalSearchTerm) { (result, error) in
                    
                    if let error = error {
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
