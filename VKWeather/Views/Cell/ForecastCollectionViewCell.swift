//
//  ForecastCollectionViewCell.swift
//  VKWeather
//
//  Created by Danil Komarov on 20.03.2024.
//

import Foundation
import UIKit

final class ForecastCollectionViewCell: UICollectionViewCell {
    static let identifier = "ForecastCollectionViewCell"
    
    private lazy var rhTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f2f3f5")
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Влажность 💧"
        return label
    }()
    
    private lazy var presTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f2f3f5")
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Давление 🌁"
        return label
    }()
    
    private lazy var windSpeedTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f2f3f5")
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Скорость ветра 💨"
        return label
    }()
    
    private lazy var windDegTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f2f3f5")
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ветер 🧭"
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f2f3f5")
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Макс"
        return label
    }()
    
    private lazy var weekLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f2f3f5")
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Макс"
        return label
    }()
    
    private lazy var maxTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f2f3f5")
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Макс"
        return label
    }()
    
    private lazy var minTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f2f3f5")
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Мин: "
        return label
    }()
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f2f3f5")
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Температура"
        return label
    }()
    
    private lazy var rhLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f2f3f5")
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Влажность"
        return label
    }()
    
    private lazy var presLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f2f3f5")
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Давление"
        return label
    }()
    
    private lazy var windSpeedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f2f3f5")
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Скорость ветра"
        return label
    }()
    
    private lazy var windDirLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f2f3f5")
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Направление ветра"
        return label
    }()
    
    private lazy var mainStackView = UIStackView()
    private lazy var detailStackView = UIStackView()
    private lazy var tempStack = UIStackView()
    private lazy var detailWindStackView = UIStackView()
    private lazy var rhStack = UIStackView()
    private lazy var windSpeedStack = UIStackView()
    private lazy var windDegStack = UIStackView()
    private lazy var presStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStack()
        setupViews()
        backgroundColor = UIColor.hexStringToUIColor(hex: "3c6a9e")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.contentView.addSubview(mainStackView)
        self.contentView.addSubview(detailStackView)
        self.contentView.addSubview(tempStack)
        
        setupConstraints()
        setupContentView()
    }
    
    private func setupContentView() {
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5 // Прозрачность тени
        layer.shadowOffset = CGSize(width: 0, height: 5) // Смещение тени относительно ячейки
        layer.shadowRadius = 5 // Радиус размытия тени
    }
    
    private func setupStack() {
        mainStackView = UIStackView(arrangedSubviews: [weekLabel, dateLabel])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.spacing = 150
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
        
        tempStack = UIStackView(arrangedSubviews: [minTempLabel, tempLabel, maxTempLabel])
        tempStack.translatesAutoresizingMaskIntoConstraints = false
        tempStack.axis = .horizontal
        tempStack.alignment = .center
        tempStack.spacing = 10
        
        rhStack = UIStackView(arrangedSubviews: [rhTitle, rhLabel])
        rhStack.translatesAutoresizingMaskIntoConstraints = false
        rhStack.axis = .horizontal
        rhStack.alignment = .leading
        rhStack.spacing = 15
        
        windSpeedStack = UIStackView(arrangedSubviews: [windSpeedTitle, windSpeedLabel])
        windSpeedStack.translatesAutoresizingMaskIntoConstraints = false
        windSpeedStack.axis = .horizontal
        windSpeedStack.alignment = .leading
        windSpeedStack.spacing = 15
        
        windDegStack = UIStackView(arrangedSubviews: [windDegTitle, windDirLabel])
        windDegStack.translatesAutoresizingMaskIntoConstraints = false
        windDegStack.axis = .horizontal
        windDegStack.alignment = .leading
        windDegStack.spacing = 15
        
        presStack = UIStackView(arrangedSubviews: [presTitle, presLabel])
        presStack.translatesAutoresizingMaskIntoConstraints = false
        presStack.axis = .horizontal
        presStack.alignment = .leading
        presStack.spacing = 15
        
        detailStackView = UIStackView(arrangedSubviews: [rhStack, presStack, windSpeedStack, windDegStack])
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.axis = .vertical
        detailStackView.alignment = .leading
        detailStackView.spacing = 4
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            
            tempStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tempStack.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 3),
            
            detailStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            detailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            detailStackView.topAnchor.constraint(equalTo: tempStack.bottomAnchor, constant: 5),
            detailStackView.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func configure(viewModel: ForecastWeatherData?) {
        dateLabel.text = viewModel?.date
        weekLabel.text = viewModel?.week
        tempLabel.text = (viewModel?.temp ?? "0") + " °C"
        maxTempLabel.text = "↑ " + (viewModel?.tempMax ?? "0") + "°"
        minTempLabel.text = "↓ " + (viewModel?.tempMin ?? "0") + "°"
        
        rhLabel.text = (viewModel?.rh ?? "0") + "%"
        presLabel.text = (viewModel?.pres ?? " ") + " мм рт. с."
        windSpeedLabel.text = (viewModel?.windSpd ?? "") + " м/c"
        windDirLabel.text = (viewModel?.windDir ?? "")
    }

}
