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
        case firstSection(Cells?)
        case secondSection(ForecastWeatherData)
    }
    
    enum Cells: Int, CaseIterable {
        case mainTemp
        case detailTemp
        case parameters
        case windSpeed
        case windDeg
        case humidity
        case press
        case clouds
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private weak var collectionView: UICollectionView?
    private var dataSource: DataSource?
    private var snapshot = DataSourceSnapshot()
    
    private var cellTypes: [Cells] {
        var cells: [Cells] = []
        cells.append(.mainTemp)
        cells.append(.detailTemp)
        cells.append(.parameters)
        cells.append(.windSpeed)
        cells.append(.windDeg)
        cells.append(.humidity)
        cells.append(.press)
        cells.append(.clouds)
        return cells
    }
    
    private var cellViewModelByType: [Cells: CellProtocol]?

    init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
//        self.collectionView?.backgroundColor = UIColor.hexStringToUIColor(hex: "92b2d6")
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.delegate = self
        self.collectionView?.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.identifier)
        self.collectionView?.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: ForecastCollectionViewCell.identifier)
    }
    
    private func applyCurrentSnapshot(weather: CurrentWeatherData) {
        mapCell(weather: weather)
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        
        cellTypes.forEach{ item in
            snapshot.appendItems([.firstSection(item)])
        }
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func applyForecastSnapshot(weather: [ForecastWeatherData]) {
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
    
    private func mapCell(weather: CurrentWeatherData) {
        cellViewModelByType = [
            .mainTemp: DefaultCollectionCellViewModel (
                title: "Сегодня",
                subtitle: weather.today ?? " ", 
                addInfo: nil,
                subtitleSecond: (weather.temp ?? " ") + " °C",
                icon: nil
            ),
            .detailTemp: DefaultCollectionCellViewModel(
                title: "Мин. ↓: " + (weather.tempMin ?? " ") + "°",
                subtitle:"Макс. ↑: " +  (weather.tempMax ?? " ") + "°", 
                addInfo: nil ,
                subtitleSecond: nil,
                icon: nil
            ),
            .parameters: DefaultCollectionCellViewModel(
                title: weather.parameters ?? " ",
                subtitle: nil, 
                addInfo: nil,
                subtitleSecond: nil,
                icon: nil
            ),
            .windSpeed: DefaultCollectionCellViewModel(
                title: "💨 Скорость ветра ",
                subtitle: nil,
                addInfo: (weather.windSpeed ?? " ") + " м/c",
                subtitleSecond: nil,
                icon: nil
            ),
            .windDeg: DefaultCollectionCellViewModel(
                title: "🧭 Ветер ",
                subtitle: nil,
                addInfo: weather.windDeg ?? " ",
                subtitleSecond: nil,
                icon: nil
            ),
            .humidity: DefaultCollectionCellViewModel(
                title: "💧 Влажность ",
                subtitle: nil,
                addInfo: (weather.humidity ?? " ") + " %",
                subtitleSecond: nil,
                icon: nil
            ),
            .press: DefaultCollectionCellViewModel(
                title: "🌁 Давление ",
                subtitle: nil,
                addInfo: (weather.pressure ?? " ") + " мм рт. с.",
                subtitleSecond: nil,
                icon: nil
            ),
            .clouds: DefaultCollectionCellViewModel(
                title: "☁️ Облачность ",
                subtitle: nil,
                addInfo: (weather.clouds ?? " ") + " %",
                subtitleSecond: nil,
                icon: nil
            ),
        ]
    }
    
    //MARK: Method for VC
    
    func reloadCurr(_ data: CurrentWeatherData?) {
        configureCollectionViewDataSource()
        guard let detailDataSource = data else { return }
        applyCurrentSnapshot(weather: detailDataSource)
        reload()
    }
    
    func reloadForecast(_ data: [ForecastWeatherData]?) {
        configureCollectionViewDataSource()
        guard let forecastDataSource = data else { return }
        applyForecastSnapshot(weather: forecastDataSource)
        reload()
    }
    
}

//MARK: - UICollectionViewDataSource

extension CollectionViewAdapter {
    
    private func configureCollectionViewDataSource() {
        dataSource = DataSource(collectionView: collectionView ?? UICollectionView(), cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            switch itemIdentifier {
            case .firstSection(let one):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as? DetailCollectionViewCell
                let viewModel = self.cellViewModelByType?[one ?? .detailTemp]
                cell?.configure(viewModel: viewModel)
                return cell
            case .secondSection(let two):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.identifier, for: indexPath) as? ForecastCollectionViewCell
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
            if indexPath.item >= 1 {
                return CGSize(width: collectionView.bounds.width - 32, height: collectionView.bounds.height / 13)
            } else {
                return CGSize(width: collectionView.bounds.width - 32, height: collectionView.bounds.height / 6.5)
            }
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
