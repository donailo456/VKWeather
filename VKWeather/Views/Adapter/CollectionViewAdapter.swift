//
//  CollectionViewAdapter.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import Foundation
import UIKit

final class CollectionViewAdapter: NSObject {
    enum Section {
        case main
    }
    
    private weak var collectionView: UICollectionView?
    
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.collectionView?.delegate = self
        self.collectionView?.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.indetifire)
        
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewAdapter: UICollectionViewDelegateFlowLayout {
    
}
