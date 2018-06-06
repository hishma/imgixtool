//
//  URL.swift
//  DPG
//
//  Created by Jeff Johnston on 12/3/16.
//  Copyright © 2016 Jeff Johnston. All rights reserved.
//

import Foundation

extension URL {
    /// Returns the type identifier (UTI) of a valid file URL.
    var typeIdentifier: String? {
        guard isFileURL else { return nil }
        do {
            return try resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier
        } catch let error as NSError {
            print(error.code)
            print(error.domain)
            return nil
        }
    }
    
    /// Returns the localized name of a valid file URL.
    var localizedName: String? {
        guard isFileURL else { return nil }
        do {
            return try resourceValues(forKeys: [.localizedNameKey]).localizedName
        } catch let error as NSError {
            print(error.code)
            print(error.domain)
            return nil
        }
    }
}
