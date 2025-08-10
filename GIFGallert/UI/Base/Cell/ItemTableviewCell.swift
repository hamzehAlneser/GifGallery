//
//  ItemTableviewCell.swift
//  GIFGallert
//
//  Created by Hamzeh on 09/08/2025.
//

import UIKit

final class ItemTableviewCell: UITableViewCell {
    private var viewModel: ItemTableviewCellVM?
    // MARK: - UI Properties
    static let reuseIdentifier = "ItemTableviewCell"
    private let shadowView = UIView()
    private let containerView = UIView()
    private let gifImageView = UIImageView()
    private let titleLabel = UILabel(style: .body)
    private let usernameLabel = UILabel(style: .title)
    private let favoriteButton = UIButton()
    
    //MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetShadowAndContainerViews()
        setupShadowViewUI()
        setupContainerViewUI()
    }
    
    
    //MARK: - Setup
    func configure(with viewModel: ItemTableviewCellVM) {
        self.viewModel = viewModel
        let username = viewModel.username.isEmpty ? "Anonymous" : viewModel.username
        titleLabel.text = viewModel.title
        usernameLabel.text = username
        gifImageView.image = viewModel.image
        updateFavoriteLogo(isfavorite: viewModel.isFavorite)
        
        viewModel.onFavoriteStateChanged = { [weak self] isFavorite in
            DispatchQueue.main.async {
                self?.updateFavoriteLogo(isfavorite: isFavorite)
            }
        }
    }
    
    func updateImage(using image: UIImage?) {
        gifImageView.image = image
    }
    
    func updateFavoriteLogo(isfavorite: Bool) {
        favoriteButton.setImage(UIImage(systemName: isfavorite ? "star.fill" : "star"), for: .normal)
    }
}

//MARK: - UI
extension ItemTableviewCell {
    private func setupUI() {
        selectionStyle = .none
        setupHierarchy()
        setupShadowViewUI()
        setupContainerViewUI()
        setupLabelsUI()
        setupGIFImageViewUI()
        setupFavoriteButtonUI()
    }
    private func setupHierarchy() {
        contentView.addSubviews(shadowView.useCodeLayout())
        
        shadowView.addSubviews(
            containerView.useCodeLayout(),
            gifImageView.useCodeLayout(),
            titleLabel.useCodeLayout(),
            usernameLabel.useCodeLayout(),
            favoriteButton.useCodeLayout()
        )
    }
    
    private func setupShadowViewUI() {
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.15
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
        shadowView.layer.shadowRadius = 5
        shadowView.layer.cornerRadius = 5
        shadowView.backgroundColor = .clear
    }

    
    private func setupContainerViewUI() {
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = .white
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    private func setupLabelsUI() {
        usernameLabel.numberOfLines = 0
        usernameLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupGIFImageViewUI() {
        gifImageView.contentMode = .scaleAspectFill
        gifImageView.clipsToBounds = true
        gifImageView.layer.cornerRadius = 8
    }
    
    private func setupFavoriteButtonUI() {
        favoriteButton.addTarget(self, action: #selector(favroiteTapped), for: .touchUpInside)
        updateFavoriteLogo(isfavorite: false)
    }
    
    @objc private func favroiteTapped() {
        viewModel?.onFavoriteTapped?()
    }
    
    private func resetShadowAndContainerViews() {
        shadowView.layer.shadowColor = nil
        shadowView.layer.shadowOpacity = 0
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 0
        shadowView.layer.cornerRadius = 0
        shadowView.backgroundColor = .clear
        
        containerView.layer.cornerRadius = 0
        containerView.layer.masksToBounds = false
        containerView.backgroundColor = .clear
        containerView.layer.borderWidth = 0
        containerView.layer.borderColor = nil
    }
}

//MARK: - Layout
extension ItemTableviewCell {
    private func setupLayout() {
        setupShahdowViewLayout()
        setupContainerViewLayout()
        setupGifImageLayout()
        setupFavoriteButtonLayout()
        setupTitleLabelLayout()
        setupUsernameLabelLayout()
    }
    
    private func setupShahdowViewLayout() {
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }
    
    private func setupContainerViewLayout() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
        ])
    }
    
    private func setupGifImageLayout() {
        NSLayoutConstraint.activate([
            gifImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            gifImageView.widthAnchor.constraint(equalToConstant: 70),
            gifImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            gifImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        ])
    }
    
    private func setupUsernameLabelLayout() {
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            usernameLabel.leadingAnchor.constraint(equalTo: gifImageView.trailingAnchor, constant: 15),
            usernameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupTitleLabelLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: gifImageView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
    }
    
    private func setupFavoriteButtonLayout() {
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 7),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
    }
}
