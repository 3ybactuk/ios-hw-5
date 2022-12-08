//
//  NewsListViewController.swift
//  nvshubin_1PW5
//
//  Created by Nikita on 06.12.2022.

import UIKit

class NewsListViewController: UIViewController, SkeletonDisplayable {
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var isLoading = false
    private var newsViewModels = [NewsViewModel]()
    public static let imageCache = NSCache<NSString, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isLoading {
            showSkeleton()
        } else {
            hideSkeleton()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        configureTableView()
        setupNavbar()
        fetchNews()
    }
    
    private func setupNavbar() {
        navigationItem.title = "Articles"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.counterclockwise"),
            style: .plain,
            target: self,
            action: #selector(refresh)
        )
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    
    private func configureTableView() {
        setTableViewUI()
        setTableViewDelegate()
        setTableViewCell()
    }
    
    private func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setTableViewUI() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = 120
        tableView.pinLeft(to: view)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view)
    }
    
    private func setTableViewCell() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    }
    
    @objc
    private func goBack() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func refresh() {
        fetchNews()
    }
    
    private func fetchNews() {
        let key = "64405d81bd2e470eaff06000cdbbaaea"
        let nam = NewsAPIManager()
        newsViewModels = []
        
        self.isLoading = true
        self.showSkeleton()
        nam.getArticles(source: .Polygon, key: key) { data in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let jsonArray = json as? [String: AnyObject] {

                    if let articles = jsonArray["articles"] as? [[String : AnyObject]] {
                        for article in articles {
                            let title = article["title"] as? String
                            let description = article["description"] as? String
                            let imageURL = article["urlToImage"] as? String
                            let articleURL = article["url"] as? String

                            self.newsViewModels.append(                            NewsViewModel(title: title ?? "None", description:  description ?? "None", imageURL: URL(string: imageURL ?? ""), articleURL: URL(string: articleURL ?? ""))
                            )
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hideSkeleton()
                    self.tableView.reloadData()
                }
            } catch {
                print("error serializing JSON: \(error)")
            }
        }
    }
}

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 5
        } else {
            return newsViewModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if isLoading {
            let viewModel = NewsViewModel(title: "AAAAA", description: "AAAAA", imageURL: URL(string: ""), articleURL: URL(string: ""))
            if let newsCell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell {
                newsCell.configure(viewModel)
                return newsCell
            }
        } else {
            let viewModel = newsViewModels[indexPath.row]
            if let newsCell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell {
                newsCell.configure(viewModel)
                return newsCell
            }
        }
        return UITableViewCell()
    }
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
            let newsVC = NewsViewController()
            newsVC.configure(with: newsViewModels[indexPath.row])
            navigationController?.pushViewController(newsVC, animated: true)
        }
    }
}
