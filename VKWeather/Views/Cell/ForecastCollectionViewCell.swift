//
//  ForecastCollectionViewCell.swift
//  VKWeather
//
//  Created by Danil Komarov on 20.03.2024.
//

import Foundation
import UIKit

final class ForecastCollectionViewCell: UICollectionViewCell {
    static let indetifire = "ForecastCollectionViewCell"
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Макс"
        return label
    }()
    
    private let maxTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Макс"
        return label
    }()
    
    private let minTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Мин: "
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Температура"
        return label
    }()
    
    private let rhLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Влажность"
        return label
    }()
    
    private let presLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Давление"
        return label
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Скорость ветра"
        return label
    }()
    
    private let windDirLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Направление ветра"
        return label
    }()
    
    private var mainStackView = UIStackView()
    private var detailStackView = UIStackView()
    private var detailWindStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStack()
        setupViews()
        backgroundColor = UIColor.hexStringToUIColor(hex: "#528bcc")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.contentView.addSubview(mainStackView)
        self.contentView.addSubview(detailStackView)
        
        setupConstraints()
        setupContentView()
    }
    
    private func setupContentView() {
        //        layer.borderWidth = 1
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5 // Прозрачность тени
        layer.shadowOffset = CGSize(width: 0, height: 2) // Смещение тени относительно ячейки
        layer.shadowRadius = 2 // Радиус размытия тени
        //        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setupStack() {
        mainStackView = UIStackView(arrangedSubviews: [dateLabel, minTempLabel, tempLabel, maxTempLabel])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.spacing = 10
        
        detailStackView = UIStackView(arrangedSubviews: [rhLabel, presLabel, windSpeedLabel, windDirLabel])
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.axis = .vertical
        detailStackView.alignment = .leading
        detailStackView.spacing = 5
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            mainStackView.widthAnchor.constraint(equalToConstant: 60),
            
            detailStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            detailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            detailStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 5),
            detailStackView.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func configure(viewModel: ForecastCellViewModel?) {
        dateLabel.text = viewModel?.date
        tempLabel.text = (viewModel?.temp ?? "0") + " °C"
        maxTempLabel.text = "↑ " + (viewModel?.tempMax ?? "0") + "°"
        minTempLabel.text = "↓ " + (viewModel?.tempMin ?? "0") + "°"
        
        rhLabel.text = "Влажность: " + (viewModel?.rh ?? "0") + "%"
        presLabel.text = "Давление: " + (viewModel?.pres ?? " ") + " мм рт. с."
        windSpeedLabel.text = "Скорость ветра: " + (viewModel?.windSpd ?? "") + " м/c"
        windDirLabel.text = "Направление ветра: " + (viewModel?.windDir ?? "")
    }

}
