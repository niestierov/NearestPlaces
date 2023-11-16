//
//  ListPlaceTableViewCell.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 13.11.2023.
//

import UIKit

class ListPlaceTableViewCell: UITableViewCell {
    private enum Constant {
        static let nameTitle = "Name: "
        static let vicinityTitle = "Address: "
        static let verticalInset: CGFloat = 20
        static let horizontalInset: CGFloat = 20
        static let imageViewWidth: CGFloat = 50
    }
    
    // MARK: - Properties -
    
    static let identifier = "ListPlaceTableViewCell"

    // MARK: - UIComponents -
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 10
        return view
    }()
    private let verticalStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 15
        return view
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    private let vicinityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    private let iconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerCurve = .continuous
        image.layer.cornerRadius = 25
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    // MARK: - LifeCycle -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    // MARK: - Iternal -
    func configure(name: String, vicinity: String) {
        nameLabel.text = Constant.nameTitle + name
        vicinityLabel.text = Constant.vicinityTitle + vicinity
        //iconImageView.image = icon
    }
}

private extension ListPlaceTableViewCell {
    func setupView() {
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(vicinityLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.verticalInset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.verticalInset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.horizontalInset),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.horizontalInset),
            
            iconImageView.widthAnchor.constraint(equalToConstant: Constant.imageViewWidth)
        ])
    }
}
