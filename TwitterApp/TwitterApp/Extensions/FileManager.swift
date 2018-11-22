//
//  FileManager.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-20.
//  Copyright © 2018 Heikki. All rights reserved.
//

import Foundation

extension FileManager {
    class func documentsDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    class func cachesDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}
