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
    enum Item: Hashable {
        case firstSection(CurrentWeatherData)
        case secondSection(ForecastWeatherData)
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private weak var collectionView: UICollectionView?
    private var dataSource: DataSource?
    private var snapshot = DataSourceSnapshot()

    
    
    init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        
        setupCollectionView()
        collectionView.backgroundColor = UIColor.hexStringToUIColor(hex: "#509ec5")
    }
    
    private func setupCollectionView() {
        self.collectionView?.delegate = self
        self.collectionView?.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.indetifire)
        self.collectionView?.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: ForecastCollectionViewCell.indetifire)
        
    }
    
    private func applySnapshot(weather: CurrentWeatherData) {
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems([.firstSection(weather)])
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func applySnapshotNew(weather: [ForecastWeatherData]) {
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        weather.forEach { item in
            snapshot.appendItems([.secondSection(item)])
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func reload() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    //MARK: Method for VC
    
    func reloadCurr(_ data: CurrentWeatherData?) {
        configureCollectionViewDataSource()
        guard let detailDataSource = data else { return }
        applySnapshot(weather: detailDataSource)
        reload()
    }
    
    func reloadForecast(_ data: [ForecastWeatherData]?) {
        configureCollectionViewDataSource()
        guard let forecastDataSource = data else { return }
        applySnapshotNew(weather: forecastDataSource)
        reload()
    }
    
}

//MARK: - UICollectionViewDataSource

extension CollectionViewAdapter {
    
    private func configureCollectionViewDataSource() {
        dataSource = DataSource(collectionView: collectionView ?? UICollectionView(), cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            switch itemIdentifier {
            case .firstSection(let one):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.indetifire, for: indexPath) as? DetailCollectionViewCell
                cell?.configure(viewModel: one)
                return cell
            case .secondSection(let two):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.indetifire, for: indexPath) as? ForecastCollectionViewCell
                cell?.configure(viewModel: two)
                return cell
            }
        })
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let itemIdentifier = dataSource?.itemIdentifier(for: indexPath) else {
            return CGSize(width: collectionView.bounds.width - 32, height: collectionView.bounds.height - 80)
        }
        switch itemIdentifier {
        case .firstSection:
            return CGSize(width: collectionView.bounds.width - 32, height: collectionView.bounds.height - 80)
        case .secondSection:
            return CGSize(width: collectionView.bounds.width - 32, height: collectionView.bounds.height / 4.6)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}
