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
        case detail
        case forecast
    }
    
    enum Item: Hashable {
        case detailSection(Cells?)
        case forecastSection(ForecastWeatherData)
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
    
    private var cellTypes: [Cells] = [.mainTemp, .detailTemp, .parameters, .windSpeed, .windDeg, .humidity, .press, .clouds]
    
    private var cellViewModelByType: [Cells: CellProtocol]?

    init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        
        setupCollectionView()
        configureCollectionViewDataSource()
    }
    
    private func setupCollectionView() {
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.delegate = self
        self.collectionView?.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.identifier)
        self.collectionView?.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: ForecastCollectionViewCell.identifier)
    }
    
    private func applyCurrentSnapshot(weather: CurrentWeatherData) {
        mapCell(weather: weather)
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.detail])
        
        cellTypes.forEach{ item in
            snapshot.appendItems([.detailSection(item)])
        }
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func applyForecastSnapshot(weather: [ForecastWeatherData]) {
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.forecast])
        weather.forEach { item in
            snapshot.appendItems([.forecastSection(item)])
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
        guard let detailDataSource = data else { return }
        applyCurrentSnapshot(weather: detailDataSource)
        reload()
    }
    
    func reloadForecast(_ data: [ForecastWeatherData]?) {
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
            case .detailSection(let one):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as? DetailCollectionViewCell
                let viewModel = self.cellViewModelByType?[one ?? .detailTemp]
                cell?.configure(viewModel: viewModel)
                return cell
            case .forecastSection(let two):
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
        case .detailSection:
            if indexPath.item >= 1 {
                return CGSize(width: collectionView.bounds.width - 32, height: collectionView.bounds.height / 13)
            } else {
                return CGSize(width: collectionView.bounds.width - 32, height: collectionView.bounds.height / 5.5)
            }
        case .forecastSection:
            return CGSize(width: collectionView.bounds.width - 32, height: collectionView.bounds.height / 3.8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}
