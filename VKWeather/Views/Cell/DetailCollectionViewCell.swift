//
//  MainCollectionViewCell.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import Foundation
import UIKit

final class DetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DetailCollectionViewCell"
    typealias ViewModel = DefaultCollectionCellViewModel
    
    private lazy var discriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 64, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "foo"
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сегодня"
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
    
    private lazy var addInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.hexStringToUIColor(hex: "f3fbfd")
        label.font = .systemFont(ofSize: 23, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
    
    private lazy var headStack = UIStackView()
    
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
        backgroundColor = .clear
        self.contentView.addSubview(headStack)
        self.contentView.addSubview(discriptionLabel)
        
        setupConstraints()
    }
    
    private func setupStack() {
        headStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, addInfoLabel])
        headStack.translatesAutoresizingMaskIntoConstraints = false
        headStack.axis = .horizontal
        headStack.alignment = .center
        headStack.spacing = 5
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            headStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            discriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            discriptionLabel.topAnchor.constraint(equalTo: headStack.bottomAnchor, constant: 5),
            discriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
    
    func configure(viewModel: CellProtocol?) {
        guard let viewModel = viewModel as? ViewModel else { return }
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        addInfoLabel.text = viewModel.addInfo
        discriptionLabel.text = viewModel.subtitleSecond
    }
}
