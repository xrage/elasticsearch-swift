//
//  extensions.swift
//  elasticsearch-swift
//
//  Created by Dharmendra Verma on 07/08/16.
//
//

import Foundation


internal extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
    
    func filterAllowedKeys(allowedParams: [String]) -> Dictionary<String, Any>{
        var filteredParams:[String: Any] = [:]
        for (key, value) in self{
            if allowedParams.exists(object: key as! String) {
                filteredParams[key as! String] = value
            }
        }
        return filteredParams
    }
}

internal extension Array where Element: Equatable {
    
    func removeObject(object: Element) -> [Element] {
        return filter { $0 != object }
    }
    
    func exists(object: Element) -> Bool{
        var result:Bool = false
        for i in self{
            if i == object{
                result = true
                break
            }
        }
        return result
    }
    
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}



internal extension URL {
    var fragments: [String: String] {
        var queryStrings = [String: String]()
        if let query = self.query {
            for qs in query.components(separatedBy: "&") {
                // Get the parameter name
                let key = qs.components(separatedBy: "=")[0]
                // Get the parameter value
                var value = qs.components(separatedBy: "=")[1]
                value = (value as NSString).replacingOccurrences(of: "+", with: " ")
                value = (value as NSString).removingPercentEncoding!
                queryStrings[key] = value
            }
        }
        let components = extractURLComponents(self as URL)
        queryStrings.update(other: components)
        queryStrings.update(other: ["path": self.path])
        return queryStrings
    }
}
