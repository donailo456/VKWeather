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
      case firstSection(DetailCellViewModel)
      case secondSection(ForecastCellViewModel)
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    typealias DataSourceNew = UICollectionViewDiffableDataSource<Section, ForecastCellViewModel>
    typealias DataSourceSnapshotNew = NSDiffableDataSourceSnapshot<Section, ForecastCellViewModel>
    
    private weak var collectionView: UICollectionView?
    private var dataSource: DataSource?
    private var dataSourceNew: DataSourceNew?
    private var snapshot = DataSourceSnapshot()
    private var snapshotNew = DataSourceSnapshotNew()
    private var detailDataSource: DetailCellViewModel?
    private var detailDataSourceNew: [ForecastCellViewModel]?
    
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.collectionView?.delegate = self
        self.collectionView?.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.indetifire)
        self.collectionView?.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: ForecastCollectionViewCell.indetifire)
        
    }
    
    private func applySnapshot(weather: DetailCellViewModel) {
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems([.firstSection(weather)])
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func applySnapshotNew(weather: [ForecastCellViewModel]) {
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        for item in weather {
               snapshot.appendItems([.secondSection(item)])
           }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    
//    private func dummyData() {
//        var dummyCell: [MainCellViewModel] = []
//        for _ in 0..<5 {
//            dummyCell.append(MainCellViewModel(temp: "new"))
//        }
//        applySnapshot(weather: dummyCell)
//    }
    
    func reloadCurr(_ data: DetailCellViewModel?) {
        configureCollectionViewDataSource()
        detailDataSource = data
        applySnapshot(weather: detailDataSource!)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func reloadForecast(_ data: [ForecastCellViewModel]?) {
        configureCollectionViewDataSource()
        detailDataSourceNew = data
        applySnapshotNew(weather: detailDataSourceNew ?? [])
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
}

//MARK: - UICollectionViewDataSource

extension CollectionViewAdapter {
//    private func configureCollectionViewDataSource() {
//        dataSource = DataSource(collectionView: collectionView ?? UICollectionView(), cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
//            if let model = DetailCellViewModel() as? DetailProtocol  {
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.indetifire, for: indexPath) as? DetailCollectionViewCell
//                cell?.configure(viewModel: itemIdentifier)
//                return cell
//            } else if let model = ForecastCellViewModel() as? ForecastProtocol{
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.indetifire, for: indexPath) as? ForecastCollectionViewCell
////                cell?.configure(viewModel: itemIdentifier)
//                return cell
//            }
//            
//            return UICollectionViewCell()
//        })
//    }
    
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
                // Размер для ячейки с типом .firstSection
                return CGSize(width: collectionView.bounds.width - 32, height: collectionView.bounds.height - 80)
            case .secondSection:
                // Размер для ячейки с типом .secondSection
                return CGSize(width: collectionView.bounds.width - 32, height: 80)
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
}
