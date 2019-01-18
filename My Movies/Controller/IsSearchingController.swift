//
//  IsSearchingController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

private let cellId = "Cell"

class IsSearchingController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate {
    
    var movies = [Results]()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        downloadJson(fromUrl: "https://api.themoviedb.org/3/movie/latest?api_key=c74a05860eaa0b6c8f22aa1b8342691c&language=en-US")
        view.backgroundColor = .orange
    }
    
    func setupView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(IsSearchingCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.addAnchors(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    
    func downloadJson(fromUrl: String) {
        guard let url = URL(string: fromUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let json = try JSONDecoder().decode(WebsiteResultData.self, from: data)
                DispatchQueue.main.async {
                    self.movies.append(contentsOf: json.results)
                    self.collectionView.reloadData()
                }
            } catch _ {
                print("error")
            }
            } .resume()
    }
}

extension IsSearchingController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? IsSearchingCell
        
        let movie = self.movies[indexPath.item]
        cell?.movieCoverImageView.loadImageUsingUrlString(urlstring: movieCoverImageUrl + movie.posterPath)
        cell?.movieTitleLabel.text = movie.title
        cell?.yearReleasedLabel.text = "(\(movie.releaseDate))"
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension IsSearchingController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}





