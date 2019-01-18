//
//  AddNewMovieController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class AddNewMovieController: UICollectionViewController {
    private let cellId = "Cell"
    private var MovieVC: MoviesController!
    
    var searchController: UISearchController?
    var resultsController: IsSearchingController?
    
    var popularMovies = [Results]()
    var movies = [Results]()
    var filteredMovies = [Results]()
    
    let activitityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // setup views
    func setupView() {
        collectionView.backgroundColor = .white
        collectionView.register(AddNewMovieCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavBar()
        downloadJson(fromUrl: moviesUrl)
        setupActivityIndicatorView()
    }
    
    func setupNavBar() {
        setupSearchBar()
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismissController))
    }
    
    func setupSearchBar() {
        resultsController = IsSearchingController()
        searchController = UISearchController(searchResultsController: resultsController)
        
        searchController?.searchBar.placeholder = "Search for a movie..."
        searchController?.searchBar.tintColor = .black
        searchController?.searchResultsUpdater = resultsController
        searchController?.obscuresBackgroundDuringPresentation = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func setupActivityIndicatorView() {
        view.addSubview(activitityIndicator)
        activitityIndicator.isHidden = false
        activitityIndicator.startAnimating()
        activitityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 2).isActive = true
        activitityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // actions
    @objc func handleDismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    // get api data
    func downloadJson(fromUrl: String) {
        guard let url = URL(string: fromUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let json = try JSONDecoder().decode(WebsiteResultData.self, from: data)
                DispatchQueue.main.async {
                    self.popularMovies.append(contentsOf: json.results)
                    self.activitityIndicator.isHidden = true
                    self.activitityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            } catch _ {
                print("error")
            }
            } .resume()
    }
}


extension AddNewMovieController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularMovies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AddNewMovieCell
        
        let movie = self.popularMovies[indexPath.item]
        cell?.movieCoverImageView.loadImageUsingUrlString(urlstring: movieCoverImageUrl + movie.posterPath)
        cell?.movieTitleLabel.text = movie.title
        cell?.yearReleasedLabel.text = "(\(movie.releaseDate))"
        
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

// UICollectionViewDelegateFlowLayout
extension AddNewMovieController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
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

