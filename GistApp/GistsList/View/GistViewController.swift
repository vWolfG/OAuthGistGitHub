//
//  ViewController.swift
//  GistApp
//
//  Created by User on 08/08/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import SwiftKeychainWrapper

// A class for showing TableView with user's Gists
class GistViewController: UIViewController {
    
    // MARk: - Properties
    private let gistTableView = UITableView()
    private var gistsViewModel = GistsViewModel()
    private var gists = [Gist]()
    private var isFirstLoading = true
    private let cellId = "GistCellId"
    private let disposeBag = DisposeBag()
    private var token = ""
    private let keychain = KeychainManager.sharedKeychainWrapper
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFirstLoading {
            uploadData()
        }
        isFirstLoading = false
        setupNavBar()
        setupUI()
    }

    
    // MARK: - Set up UI
    
    private func setupNavBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Gist", style: .plain, target: self, action: #selector(addNewGist))
    }
    
    private func setupUI(){
        view.addSubview(gistTableView)
        gistTableView.register(GistTableViewCell.self, forCellReuseIdentifier: cellId)
        gistTableView.dataSource = self
        gistTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gistTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gistTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gistTableView.topAnchor.constraint(equalTo: view.topAnchor),
            gistTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        
        navigationItem.title = "My Gists"
    }

    // MARK: - Private functions
    private func goToAuth(){
        let authViewController = AuthViewController()
        authViewController.oauthToken
            .subscribe(onNext: { [weak self] tokenAuth  in
                guard let self = self else {return}
                self.token = tokenAuth
                self.uploadData()
            })
        .disposed(by: disposeBag)
        present(authViewController, animated: true, completion: nil)
    }
    
    // A function for uploading Gists from GitHub
    private func uploadData(){
        self.token = keychain.string(forKey: "access_token") as! String
        guard !self.token.isEmpty else {
            goToAuth()
            return
        }
        gistsViewModel.loadGists { [weak self] (gistArray) in
            guard let self = self else { return }
            self.gists = gistArray
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.gistTableView.reloadData()
            }
        }
    }

    // MARK: - Handlers
    @objc private func addNewGist(){
        let addNewGistController = AddNewGistViewController()
        addNewGistController.delegate = self
        navigationController?.pushViewController(addNewGistController, animated: true)
    }
}
// MARK: - UITableViewDataSource Delegate
extension GistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GistTableViewCell
        guard gists.count > indexPath.row else { return cell }
        cell.setDataToCell(model: gists[indexPath.row])
        print("Cell ID:  " , indexPath.row, "count Gists: ", gists.count)
        return cell
    }
    
}

extension GistViewController: AddNewGistViewControllerDelegate{
    func AddNewGistViewControllerSaveDidTap() {
        uploadData()
    }
}
