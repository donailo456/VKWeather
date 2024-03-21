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
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 64, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "foo"
        return label
    }()
    
    private let parametersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "foo"
        return label
    }()
    
    private let maxTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Максимальная температура"
        return label
    }()
    
    private let minTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Минимальная температура: "
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сегодня"
        return label
    }()
    
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text =  "Давление: "
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Влажность: "
        return label
    }()
    
    private let cloudsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Влажность: "
        return label
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Скорость ветра: "
        return label
    }()
    
    private let windDegLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Направление ветра: "
        return label
    }()
    
    private let currDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00.00.0000"
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
    private var dateStackView = UIStackView()
    
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
        backgroundColor = UIColor.hexStringToUIColor(hex: "509ec5")
        self.contentView.addSubview(detailStackView)
        self.contentView.addSubview(mainStackView)
        self.contentView.addSubview(imageView)
        
        setupConstraints()
    }
    
    private func setupStack() {
        tempStackView = UIStackView(arrangedSubviews: [minTempLabel, maxTempLabel])
        tempStackView.translatesAutoresizingMaskIntoConstraints = false
        tempStackView.axis = .horizontal
        tempStackView.spacing = 20
        
        mainStackView = UIStackView(arrangedSubviews: [tempLabel, tempStackView, parametersLabel])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 20
        
        dateStackView = UIStackView(arrangedSubviews: [detailLabel, currDateLabel])
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        dateStackView.axis = .horizontal
        dateStackView.spacing = 5
        
        detailStackView = UIStackView(arrangedSubviews: [dateStackView, pressureLabel, cloudsLabel, windSpeedLabel, windDegLabel, humidityLabel])
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.axis = .vertical
        detailStackView.spacing = 5
        
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tempLabel.widthAnchor.constraint(equalToConstant: 165),
            tempLabel.heightAnchor.constraint(equalToConstant: 65),
            dateStackView.widthAnchor.constraint(equalToConstant: 110),
            
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainStackView.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.25),
            
            imageView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: contentView.frame.width * 0.08),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.frame.width * 0.33),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: contentView.frame.width * -0.33),
            imageView.bottomAnchor.constraint(equalTo: detailStackView.topAnchor, constant: contentView.frame.width * -0.14),
            
            detailStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.frame.width * 0.02),
            detailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: contentView.frame.width * -0.02),
            detailStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: contentView.frame.width * 0.06),
            detailStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: contentView.bounds.width / -3),
        ])
    }
    
    func configure(viewModel: CurrentWeatherData?) {
        tempLabel.text = (viewModel?.temp ?? "0") + " °C"
        parametersLabel.text = viewModel?.parameters
        maxTempLabel.text = "Макc. ↑:  " + (viewModel?.tempMax ?? "0") + "°"
        minTempLabel.text = "Мин. ↓:  " + (viewModel?.tempMin ?? "0") + "°"
        pressureLabel.text? = "Давление достигет до " + (viewModel?.pressure ?? "0") + " мм рт. с."
        cloudsLabel.text? = "Облачность составит " + (viewModel?.clouds ?? "0") + " %. "
        windSpeedLabel.text? = "Порывы ветра до " + (viewModel?.windSpeed ?? "0") + " м/c"
        humidityLabel.text? = "Влажность составит: " + (viewModel?.humidity ?? "0") + " %"
        windDegLabel.text? = "Направление ветра:  " + (viewModel?.windDeg ?? "")
        
        imageView.image = UIImage(data: viewModel?.icon ?? Data())
        today()
    }
    
    private func today() {
        let getDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        currDateLabel.text = dateFormatter.string(from: getDate)
    }
}
