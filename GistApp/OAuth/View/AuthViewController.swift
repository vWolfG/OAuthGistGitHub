//
//  AuthViewController.swift
//  GistApp
//
//  Created by User on 08/08/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import SwiftKeychainWrapper

// A class for AuthViewController
class AuthViewController: UIViewController {

    // MARK: - UI Components
    private let keychain = KeychainManager.sharedKeychainWrapper
    private let webView = WKWebView()
    private let oauth = OAuthNetwork()
    // MARK: - Properties
    
    private let oauthTokenSubject = PublishSubject<String>()
    
    var oauthToken: Observable<String> {
        return oauthTokenSubject.asObservable()
    }
 //   weak var delegate: AuthViewControllerDelegate?
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        setupUI()
        setNavBar()
        guard let request  = oauth.codeGetRequest else {return}
        webView.load(request)
        
    }

    // MARK: - Private functions
    private func setNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backButton))
    }
    
    private func setupUI(){
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
    }

    
    // MARK: - Handlers
    
    @objc private func backButton(){
        dismiss(animated: true, completion: nil)
    }

}
// MARK: - WKNavigationDelegate
extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        defer {
            decisionHandler(.allow)
        }
        
        if let url = navigationAction.request.url, url.scheme == Constans.sheme {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            
            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                oauth.code = code
                oauth.getToken {
                    self.oauthTokenSubject.onNext(self.keychain.string(forKey: "access_token") ?? "")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                return
            }
        }
    }
}

