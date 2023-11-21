//
//  PlaceListTableViewCell.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 13.11.2023.
//

import UIKit

final class PlaceListTableViewCell: UITableViewCell {
    private enum Constant {
        static let iconType = ".png"
        static let placeholderIconImage = "questionmark.circle.fill"
        static let titleNumberOfLines = 1
        static let verticalInset: CGFloat = 20
        static let horizontalInset: CGFloat = 20
        static let imageViewWidth: CGFloat = 50
        static let stackViewSpacing: CGFloat = 15
        static let defaultTitleWidth: CGFloat = 75
        
        enum Title {
            static let name = "Name:"
            static let address = "Address:"
            static let rating = "Rating:"
            static let nameOptional = "Name is missing."
            static let addressOptional = "Address is missing."
        }
    }
    
    // MARK: - UI Components -
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = Constant.stackViewSpacing
        return view
    }()
    private lazy var nameStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.axis = .horizontal
        view.alignment = .top
        view.distribution = .fill
        view.spacing = .zero
        return view
    }()
    private lazy var addressStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.axis = .horizontal
        view.alignment = .top
        view.distribution = .fill
        view.spacing = .zero
        return view
    }()
    private lazy var ratingStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.axis = .horizontal
        view.alignment = .top
        view.distribution = .fill
        view.spacing = .zero
        return view
    }()
    private lazy var nameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.Title.name
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = Constant.titleNumberOfLines
        return label
    }()
    private lazy var addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.Title.address
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = Constant.titleNumberOfLines
        return label
    }()
    private lazy var ratingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.Title.rating
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = Constant.titleNumberOfLines
        return label
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        return label
    }()
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        return label
    }()
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // MARK: - Life Cycle -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.kf.cancelDownloadTask()
        iconImageView.image = nil
    }
    
    // MARK: - Internal -
    
    func configure(place: Place) {
        let name = place.displayName?.text ?? Constant.Title.nameOptional
        let address = place.formattedAddress ?? Constant.Title.addressOptional
        let rating = place.rating ?? .zero
        let iconString = place.iconMaskBaseUri ?? ""
        let placeholderImage = UIImage(systemName: Constant.placeholderIconImage)
        
        nameLabel.text = name
        addressLabel.text = address
        ratingLabel.text = rating.stringValue
        
        DispatchQueue.main.async {
            self.iconImageView.setImage(
                with: iconString,
                type: Constant.iconType,
                placeholder: placeholderImage
            )
        }
    }
}

private extension PlaceListTableViewCell {
    func setupView() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(nameStackView)
        verticalStackView.addArrangedSubview(addressStackView)
        verticalStackView.addArrangedSubview(ratingStackView)
        
        nameStackView.addArrangedSubview(nameTitleLabel)
        nameStackView.addArrangedSubview(nameLabel)
        
        addressStackView.addArrangedSubview(addressTitleLabel)
        addressStackView.addArrangedSubview(addressLabel)
        
        ratingStackView.addArrangedSubview(ratingTitleLabel)
        ratingStackView.addArrangedSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constant.horizontalInset
            ),
            iconImageView.heightAnchor.constraint(equalToConstant: Constant.imageViewWidth),
            iconImageView.widthAnchor.constraint(equalToConstant: Constant.imageViewWidth),
            
            verticalStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constant.verticalInset
            ),
            verticalStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constant.verticalInset
            ),
            verticalStackView.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: Constant.horizontalInset
            ),
            verticalStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constant.verticalInset
            ),
            
            ratingTitleLabel.widthAnchor.constraint(equalToConstant: Constant.defaultTitleWidth),
            addressTitleLabel.widthAnchor.constraint(equalToConstant: Constant.defaultTitleWidth),
            nameTitleLabel.widthAnchor.constraint(equalToConstant: Constant.defaultTitleWidth),
        ])
    }
}
