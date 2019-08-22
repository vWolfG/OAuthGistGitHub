//
//  AddNewGistViewController.swift
//  GistApp
//
//  Created by User on 12/08/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

// A protocol for AddNewGistViewController actions
protocol AddNewGistViewControllerDelegate: AnyObject {
    func AddNewGistViewControllerSaveDidTap()
}
// A class for AddNewGistViewController
class AddNewGistViewController: UIViewController {
    // MARK: - UI Components
    private let gistNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Gist name..."
        textField.borderStyle = UITextField.BorderStyle.bezel
        return textField
    }()
    
    private let gistContentView = UITextView()
    
    // MARK: - Properties
    weak var delegate: AddNewGistViewControllerDelegate?
    private let keychain =  KeychainManager.sharedKeychainWrapper
    private let oauth = OAuthNetwork()
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUI()
    }
    // MARK: - Set up UI
    private func setupNavBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNewGist))
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        
        gistNameTextField.translatesAutoresizingMaskIntoConstraints = false
        gistContentView.translatesAutoresizingMaskIntoConstraints = false
       
        view.addSubview(gistNameTextField)
        view.addSubview(gistContentView)
      
        
        gistContentView.text = "Your Gist..."
        gistContentView.isScrollEnabled = true
        gistContentView.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            gistNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            gistNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            gistNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            
            gistContentView.topAnchor.constraint(equalTo: gistNameTextField.bottomAnchor, constant: 20),
            gistContentView.leftAnchor.constraint(equalTo: gistNameTextField.leftAnchor),
            gistContentView.rightAnchor.constraint(equalTo: gistNameTextField.rightAnchor),
            gistContentView.heightAnchor.constraint(equalToConstant: 500)
        
            
            
            ])
    }
    // MARK: - Private functions
    
    private func showAddAlert(){
        let aletController = UIAlertController(title: "", message: "Please, fill all fields...", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        aletController.addAction(okAction)
        present(aletController, animated: true, completion: nil)
    }
   

    
    // MARK: - Handlers
    
    @objc private func saveNewGist(){
        
        guard let name = gistNameTextField.text?.nilIfTrimmedEmpty else {
            showAddAlert()
            return
        }
            
        guard let content = gistContentView.text?.nilIfTrimmedEmpty else {
            showAddAlert()
            return
            
        }
        
        oauth.addGist(name: name, content: content) { (info) in
            print(info)
        }
        navigationController?.popViewController(animated: true)
    }
}
