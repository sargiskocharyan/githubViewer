//
//  GithubSearchViewController.swift
//  GithubViewer
//
//  Created by Sargis Kocharyan on 30.08.21.
//

import UIKit

class GithubSearchViewController: UIViewController {
    let repoCellIdentifier = "repoCellID"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var viewModel = GithubSearchViewModel(networkManager: GithubNetworkManager())

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    @IBAction func searhcButtonTapped(_ sender: Any) {
        if let text = searchTextField.text {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            viewModel.searchForRepo(keyword: text) {
                DispatchQueue.main.async {
                    if !self.viewModel.dataSource.isEmpty {
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func searchFieldEdited(_ sender: Any) {
        searchButton.isEnabled = !(searchTextField.text?.isEmpty ?? true)
    }
    
    private func configureUI() {
        activityIndicator.isHidden = true
        self.tableView.isHidden = true
        searchButton.isEnabled = false
        tableView.register(UINib(nibName: "RepoTableViewCell", bundle: nil), forCellReuseIdentifier: repoCellIdentifier)
    }
}

extension GithubSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: repoCellIdentifier, for: indexPath) as! RepoTableViewCell
        cell.configureWith(item: viewModel.dataSource[indexPath.row])
        return cell
    }
    
}

extension GithubSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let url = viewModel.dataSource[indexPath.row].htmlUrl {
            openUrlInBrowser(url: url)
        }
    }
    
    func openUrlInBrowser(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}

