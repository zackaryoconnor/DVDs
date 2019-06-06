//
//  MovieDetailController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 5/7/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class MovieDetailController: BaseListController {
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
        button.setTitle("X", for: .normal)
        
        return button
    }()
    
    fileprivate let cellId = "cellId"
    fileprivate let headerCellId = "headerCellId"
    
    fileprivate let closeButtonSize: CGFloat = 42
    
    var dismissHandler: (() -> ())?
    var movieInfo: SavedMovies?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MovieDetailCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 16), size: .init(width: closeButtonSize, height: closeButtonSize))
        closeButton.layer.cornerRadius = closeButtonSize / 2
    }
 
    @objc fileprivate func handleDismiss(button: UIButton) {
        closeButton.isHidden = true
        dismissHandler?()
    }
    
}




extension MovieDetailController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MovieDetailCell
        
        cell.moviesCell.movie = movieInfo
        
        closeButton.addTarget(self, action: #selector(handleDismiss(button:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId, for: indexPath)
//
//        headerCell.backgroundColor = .blue
//
//        return headerCell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return .init(width: view.frame.width, height: 400)
//    }
    
}
