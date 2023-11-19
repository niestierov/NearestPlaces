//
//  ListPlaceTableViewCell.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 13.11.2023.
//

import UIKit
import Kingfisher

class ListPlaceTableViewCell: UITableViewCell {
    private enum Constant {
        static let iconType = ".png"
        static let placeholderIconImage = "questionmark.circle.fill"
        static let verticalInset: CGFloat = 20
        static let horizontalInset: CGFloat = 20
        static let imageViewWidth: CGFloat = 50
        static let stackViewSpacing: CGFloat = 15
        static let nameOptionalTitle = "Name is missing."
        static let addressOptionalTitle = "Address is missing."
        
        enum Title {
            static let name = "Name: "
            static let address = "Address: "
            static let rating = "Rating: "
        }
    }
    
    // MARK: - UIComponents -
    
    private let verticalStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = Constant.stackViewSpacing
        return view
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        return label
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        return label
    }()
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        return label
    }()
    private let iconSVGView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
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
    
    func configure(place: Place) {
        let name = place.displayName?.text ?? Constant.nameOptionalTitle
        let address = place.formattedAddress ?? Constant.addressOptionalTitle
        let rating = String(place.rating ?? .zero)
        let iconString = place.iconMaskBaseUri ?? ""
        
        nameLabel.text = Constant.Title.name + name
        addressLabel.text = Constant.Title.address + address
        ratingLabel.text = Constant.Title.rating + String(rating)
        
        setIconImage(string: iconString)
    }
}

private extension ListPlaceTableViewCell {
    func setupView() {
        contentView.addSubview(iconSVGView)
        contentView.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(addressLabel)
        verticalStackView.addArrangedSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            iconSVGView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconSVGView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constant.horizontalInset
            ),
            iconSVGView.heightAnchor.constraint(equalToConstant: Constant.imageViewWidth),
            iconSVGView.widthAnchor.constraint(equalToConstant: Constant.imageViewWidth),
            
            verticalStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constant.verticalInset
            ),
            verticalStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constant.verticalInset
            ),
            verticalStackView.leadingAnchor.constraint(
                equalTo: iconSVGView.trailingAnchor,
                constant: Constant.horizontalInset
            ),
            verticalStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constant.verticalInset
            ),
        ])
    }
    
    func buildIconURL(string icon: String) -> URL? {
        let iconFullUrlString = icon + Constant.iconType
        
        guard let url = URL(string: iconFullUrlString) else {
            return nil
        }
        
        return url
    }
    
    func setIconImage(string icon: String) {
        let iconUrl = buildIconURL(string: icon)
        
        if let iconUrl {
            self.iconSVGView.kf.setImage(with: iconUrl)
        } else {
            self.iconSVGView.image = UIImage(systemName: Constant.placeholderIconImage)
        }
    }
}
