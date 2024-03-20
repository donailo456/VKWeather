//
//  ViewController.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    var viewModel: MainViewModel?
    
    private lazy var adapter = CollectionViewAdapter(collectionView: mainCollectionView)
    
    private lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "foo"
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let currentWeatherButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Current", for: .normal)
        return button
    }()
    
    private let dailyWeatherButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("7 days", for: .normal)
        return button
    }()
    
    
    
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupViews()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.setupLocation()
        viewModel?.onCity = { [weak self] city in
            self?.cityLabel.text = city
        }
        
    }
    
    private func setupViews() {
        view.addSubview(mainCollectionView)
        view.addSubview(stackView)
        view.addSubview(cityLabel)
        view.addSubview(activityIndicator)
        setupConstraints()
        setupStack()
        addTargetButton()
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 5),
            cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            cityLabel.bottomAnchor.constraint(equalTo: mainCollectionView.topAnchor, constant: -5),
            cityLabel.widthAnchor.constraint(equalToConstant: 180),
            
            mainCollectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupStack() {
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = .gray
        
        stackView.addArrangedSubview(currentWeatherButton)
        stackView.addArrangedSubview(dailyWeatherButton)
    }
    
    private func addTargetButton() {
        dailyWeatherButton.addTarget(self, action: #selector(dailyAction), for: .touchUpInside)
        currentWeatherButton.addTarget(self, action: #selector(currentAction), for: .touchUpInside)
    }
    
    @objc
    private func dailyAction() {
        viewModel?.mapCellDataNew()
        viewModel?.onDataReloadForecast = { [weak self] data in
            self?.adapter.reloadForecast(data)
        }
    }
    
    @objc
    private func currentAction() {
        viewModel?.mapCellData()
        viewModel?.onDataReloadCurr = { [weak self] data in
            self?.adapter.reloadCurr(data)
        }
    }
    
    
    
    private func bindViewModel() {
//        viewModel?.getCurrentWeather("10.99", "44.34")
        viewModel?.mapCellDataNew()
//        viewModel?.getForecastWeather("10.99", "44.34")
        viewModel?.onDataReloadCurr = { [weak self] data in
            self?.adapter.reloadCurr(data)
        }
        viewModel?.onDataReloadForecast = { [weak self] data in
            self?.adapter.reloadForecast(data)
        }
    }


}

