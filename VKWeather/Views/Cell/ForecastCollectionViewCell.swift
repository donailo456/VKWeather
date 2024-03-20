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
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Макс"
        return label
    }()
    
    private let minTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 19, weight: .bold)
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
    
    private var mainStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .blue
        setupStack()
        setupViews()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.contentView.addSubview(mainStackView)
        
        setupConstraints()
    }
    
    private func setupStack() {
        mainStackView = UIStackView(arrangedSubviews: [dateLabel, minTempLabel, tempLabel, maxTempLabel])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.backgroundColor = .green
        mainStackView.spacing = 5
        
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainStackView.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func configure(viewModel: ForecastCellViewModel?) {
        dateLabel.text = viewModel?.date
        tempLabel.text = (viewModel?.temp ?? "0") + " C"
        maxTempLabel.text = (viewModel?.tempMax ?? "0") + " C"
        minTempLabel.text = (viewModel?.tempMin ?? "0") + " C"
    }
}
