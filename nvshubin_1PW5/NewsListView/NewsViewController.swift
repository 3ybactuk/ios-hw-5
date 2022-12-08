//
//  NewsViewController.swift
//  nvshubin_1PW5
//
//  Created by Nikita on 06.12.2022.
//

import UIKit
final class NewsViewController: UIViewController {
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavbar()
        setImageView()
        setTitleLabel()
        setDescriptionLabel()
    }
    
    private func setupNavbar() {
        navigationItem.title = "News"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    private func setImageView() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.pin(to: view, [.left, .right])
        imageView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        imageView.pinHeight(to: imageView.widthAnchor, 1)
    }

    private func setTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: imageView.bottomAnchor, 12)
        titleLabel.pin(to: view, [.left, .right], 16)
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
    }

    private func setDescriptionLabel() {
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryLabel
        view.addSubview(descriptionLabel)
        descriptionLabel.pin(to: view, [.left, .right], 16)
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 8)
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: NewsViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description

        if let image = NewsListViewController.imageCache.object(forKey: (viewModel.imageURL?.absoluteString ?? "") as NSString) as? UIImage {
            imageView.image = image
        }
        else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in guard let data = data else {
                return
            }
            
            viewModel.imageData = data
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data)
                NewsListViewController.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                self?.imageView.image = imageToCache
                }
            }.resume()
        }
    }
    
    // MARK: - Objc functions
    @objc
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

