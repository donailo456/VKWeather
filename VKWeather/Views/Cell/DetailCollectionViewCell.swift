//
//  MainCollectionViewCell.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import Foundation
import UIKit

final class DetailCollectionViewCell: UICollectionViewCell {
    static let indetifire = "DetailCollectionViewCell"
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "foo"
        return label
    }()
    
    private let parametersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "foo"
        return label
    }()
    
    private let maxTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Максимальная температура"
        return label
    }()
    
    private let minTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Минимальная температура: "
        return label
    }()
    
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Атфосферное давление: "
        return label
    }()
    
    private let cloudsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "foo"
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Влажность: "
        return label
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Скорость ветра: "
        return label
    }()
    private let currDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00-0000-00"
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .white
        return imageView
    }()
    
    
    private var mainStackView = UIStackView()
    private var detailStackView = UIStackView()
    private var tempStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStack()
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.contentView.addSubview(detailStackView)
        self.contentView.addSubview(mainStackView)
        self.contentView.addSubview(imageView)
        
        setupConstraints()
    }
    
    private func setupStack() {
        tempStackView = UIStackView(arrangedSubviews: [minTempLabel, maxTempLabel])
        tempStackView.translatesAutoresizingMaskIntoConstraints = false
        tempStackView.axis = .horizontal
//        tempStackView.backgroundColor = .white
        tempStackView.spacing = 5
        
        mainStackView = UIStackView(arrangedSubviews: [tempLabel, tempStackView, parametersLabel])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
//        mainStackView.backgroundColor = .green
        mainStackView.spacing = 5
        
        detailStackView = UIStackView(arrangedSubviews: [pressureLabel, cloudsLabel, humidityLabel, windSpeedLabel])
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.axis = .vertical
//        detailStackView.backgroundColor = .white
        detailStackView.spacing = 5
        
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainStackView.heightAnchor.constraint(equalToConstant: 120),
            
            imageView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            detailStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            detailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            detailStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            detailStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: contentView.bounds.width / -2.8),
        ])
    }
    
    func configure(viewModel: DetailCellViewModel?) {
        tempLabel.text = (viewModel?.temp ?? "0") + " C"
        parametersLabel.text = viewModel?.parameters
        maxTempLabel.text = "Макc.: " + (viewModel?.tempMax ?? "0") + " C"
        minTempLabel.text = "Мин.: " + (viewModel?.tempMin ?? "0") + " C"
        pressureLabel.text? = "Атфосферное давление: " + (viewModel?.pressure ?? "0")
        cloudsLabel.text? = "Облачность " + (viewModel?.clouds ?? "0") + "%"
        humidityLabel.text? = "Влажность: " + (viewModel?.humidity ?? "0")
        windSpeedLabel.text? = "Скорость ветра: " + (viewModel?.windSpeed ?? "0")
        
        imageView.image = viewModel?.icon
    }
}
