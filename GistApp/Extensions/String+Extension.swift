//
//  String+Extension.swift
//  GistApp
//
//  Created by User on 12/08/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

extension String {
    
    func trimmed() -> String {
        return (self as NSString).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var nilIfEmpty: String? {
        if isEmpty {
            return nil
        }
        return self
    }
    
    var nilIfTrimmedEmpty: String? {
        return trimmed().nilIfEmpty
    }
    
}
