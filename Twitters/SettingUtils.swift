//
//  SettingUtils.swift
//  Twitters
//
//  Created by Nguyen Quang Ngoc Tan on 3/3/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation

class SettingUtils {
    
    static func loadSetting(key: String, defaultValue: Any?) -> Any? {
        let defaults = UserDefaults.standard
        guard let returnValue = defaults.object(forKey: key) else {
            return defaultValue
        }
        return NSKeyedUnarchiver.unarchiveObject(with: returnValue as! Data)
    }
    
    static func saveSetting(configurations: [String : Any]) {
        let defaults = UserDefaults.standard
        for (key, object) in configurations {
            let data = NSKeyedArchiver.archivedData(withRootObject: object)
            defaults.set(data, forKey: key)
        }
        defaults.synchronize()
    }
    
    static func removeSetting(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
}
