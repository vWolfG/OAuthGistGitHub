//
//  KeychainManager.swift
//  GistApp
//
//  Created by User on 16/08/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

// A struct for managing Keychain
struct KeychainManager{
    private struct Keys {
        static let appInstalled = "keychain_app_installed"
    }
    /// Shared KeychainWrapper instance to use throughout the app
    static let sharedKeychainWrapper: KeychainWrapper = {
        let userDefaults = UserDefaults.standard
        let isAppInstalled = userDefaults.bool(forKey: Keys.appInstalled)
        if !isAppInstalled {
            KeychainWrapper.standard.removeAllKeys()
            userDefaults.set(true, forKey: Keys.appInstalled)
            userDefaults.synchronize()
        }
        return KeychainWrapper.standard
    }()
}
