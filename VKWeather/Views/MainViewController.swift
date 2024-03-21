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
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Поиск геопозиции..."
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
        //        button.backgroundColor = .red
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        button.setTitle("Сейчас", for: .normal)
        return button
    }()
    
    private let dailyWeatherButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.titleLabel?.alpha = 0.5
        //        button.backgroundColor = .blue
        button.setTitle("Прогноз", for: .normal)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //MARK: - Setup View
    
    private func setupViews() {
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "#346cad")
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
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        
        stackView.addArrangedSubview(currentWeatherButton)
        stackView.addArrangedSubview(dailyWeatherButton)
    }
    
    private func addTargetButton() {
        dailyWeatherButton.addTarget(self, action: #selector(dailyAction), for: .touchUpInside)
        currentWeatherButton.addTarget(self, action: #selector(currentAction), for: .touchUpInside)
    }
    
    @objc
    private func dailyAction(_ sender: UIButton) {
        setupButtons(buttonTouch: sender, buttonUntouch: currentWeatherButton)
//        viewModel?.mapForecastCellData()
        viewModel?.transmissionForecastData()
        viewModel?.onDataReloadForecast = { [weak self] data in
            self?.adapter.reloadForecast(data)
        }
    }
    
    @objc
    private func currentAction(_ sender: UIButton) {
        setupButtons(buttonTouch: sender, buttonUntouch: dailyWeatherButton)
//        viewModel?.mapDetailCellData()
        viewModel?.transmissionCurrData()
        viewModel?.onDataReloadCurr = { [weak self] data in
            self?.adapter.reloadCurr(data)
        }
    }
    
    private func setupButtons(buttonTouch: UIButton, buttonUntouch: UIButton) {
        buttonTouch.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        buttonTouch.titleLabel?.alpha = 1
        
        buttonUntouch.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        buttonUntouch.titleLabel?.alpha = 0.5
    }
    
    
    
    private func bindViewModel() {
        self.viewModel?.onIsLoading = { [weak self] isLoading in
            isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
        viewModel?.onDataReloadCurr = { [weak self] data in
            self?.adapter.reloadCurr(data)
        }
        viewModel?.onDataReloadForecast = { [weak self] data in
            self?.adapter.reloadForecast(data)
        }
    }
    
    
}

