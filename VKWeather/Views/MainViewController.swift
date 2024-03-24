//
//  ViewController.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    private lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Поиск геопозиции..."
        return label
    }()
    
    private lazy var currentWeatherButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        button.setTitle("Сейчас", for: .normal)
        button.addTarget(self, action: #selector(currentAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var dailyWeatherButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.titleLabel?.alpha = 0.5
        button.setTitle("Прогноз", for: .normal)
        button.addTarget(self, action: #selector(dailyAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    private lazy var searchField: UITextField = {
        let textField =  UITextField()
        textField.placeholder = "Поиск города"
        textField.font = .systemFont(ofSize: 15, weight: .bold)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10.0
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "CurrLocation"), for: .normal)
        button.addTarget(self, action: #selector(currLocationAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var viewModel: MainViewModel?
    
    private lazy var adapter = CollectionViewAdapter(collectionView: mainCollectionView)
    
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
//        view.backgroundColor = UIColor.hexStringToUIColor(hex: "3c6a9e")
        setupBackgroudColor()
        view.addSubview(mainCollectionView)
        view.addSubview(locationButton)
        view.addSubview(searchField)
        view.addSubview(stackView)
        view.addSubview(cityLabel)
        view.addSubview(activityIndicator)
        setupConstraints()
        setupStack()
    }
    
    private func setupBackgroudColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        let startColor = UIColor.hexStringToUIColor(hex: "92b2d6").cgColor
        let endColor = UIColor.hexStringToUIColor(hex: "3c6a9e").cgColor
        gradientLayer.colors = [startColor, endColor] // Устанавливаем цвета для градиента
        
        // Настройка направления градиента (необязательно)
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        
        // Добавляем градиентный слой на задний план представления
        view?.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: locationButton.leadingAnchor, constant: -10),
            
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            locationButton.centerYAnchor.constraint(equalTo: searchField.centerYAnchor),
            locationButton.heightAnchor.constraint(equalToConstant: 25),
            locationButton.widthAnchor.constraint(equalToConstant: 25),
            
            stackView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            cityLabel.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            cityLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
        stackView.addArrangedSubview(currentWeatherButton)
        stackView.addArrangedSubview(dailyWeatherButton)
    }

    
    @objc
    private func dailyAction(_ sender: UIButton) {
        setupButtons(buttonTouch: sender, buttonUntouch: currentWeatherButton)
        viewModel?.transmissionForecastData()
        viewModel?.onDataReloadForecast = { [weak self] data in
            self?.adapter.reloadForecast(data)
        }
    }
    
    @objc
    private func currentAction(_ sender: UIButton) {
        setupButtons(buttonTouch: sender, buttonUntouch: dailyWeatherButton)
        viewModel?.transmissionCurrData()
        viewModel?.onDataReloadCurr = { [weak self] data in
            self?.adapter.reloadCurr(data)
        }
    }
    @objc
    private func currLocationAction() {
        viewModel?.setupLocation()
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

//MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              !text.isEmpty else {
            return
        }
        viewModel?.seacrhCoordinat(text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
}

