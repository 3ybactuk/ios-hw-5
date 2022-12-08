//
//  NewsCell.swift
//  nvshubin_1PW5
//
//  Created by Nikita on 06.12.2022.
//

import UIKit

final class NewsCell: UITableViewCell {
    static let reuseIdentifier = "NewsCell"
    private let newsImageView = UIImageView()
    private let newsTitleLabel = UILabel()
    private let newsDescriptionLabel = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupView() {
        setupImageView()
        setupTitleLabel()
        setupDescriptionLabel()
    }
    
    private func setupImageView() {
        newsImageView.layer.cornerRadius = 8
        newsImageView.layer.cornerCurve = .continuous
        newsImageView.clipsToBounds = true
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(newsImageView)
        newsImageView.pin(to: contentView, [.top, .bottom], 12)
        newsImageView.pinLeft(to: contentView, 16)
        newsImageView.pinWidth(to: newsImageView.heightAnchor)
    }
    
    private func setupTitleLabel() {
        newsTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        newsTitleLabel.textColor = .label
        newsTitleLabel.numberOfLines = 1
        contentView.addSubview(newsTitleLabel)
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        newsTitleLabel.setHeight(Int(newsTitleLabel.font.lineHeight))
        newsTitleLabel.pinLeft(to: newsImageView.trailingAnchor, 12)
        newsTitleLabel.pin(to: contentView, [.top, .right], 12)
    }
    
    private func setupDescriptionLabel() {
        newsDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        newsDescriptionLabel.textColor = .secondaryLabel
        newsDescriptionLabel.numberOfLines = 0
        contentView.addSubview(newsDescriptionLabel)
        newsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        newsDescriptionLabel.pinLeft(to: newsImageView.trailingAnchor, 12)
        newsDescriptionLabel.pinTop(to: newsTitleLabel.bottomAnchor, 12)
        newsDescriptionLabel.pinRight(to: contentView, 16)
        newsDescriptionLabel.pinBottom(to: contentView, 12)
    }
    
    public func configure(_ viewModel: NewsViewModel) {
        newsTitleLabel.text = viewModel.title
        newsDescriptionLabel.text = viewModel.description

        if let image = NewsListViewController.imageCache.object(forKey: (viewModel.imageURL?.absoluteString ?? "") as NSString) as? UIImage {
            newsImageView.image = image
        } else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in guard let data = data else {
                return
            }
            viewModel.imageData = data
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data)
                NewsListViewController.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                self?.newsImageView.image = imageToCache
                }
            }.resume()
        }
    }
}
