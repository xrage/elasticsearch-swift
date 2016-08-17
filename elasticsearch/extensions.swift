//
//  extensions.swift
//  elasticsearch-swift
//
//  Created by Dharmendra Verma on 07/08/16.
//
//

import Foundation


extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

extension Array where Element: Equatable {
    func removeObject(object: Element) -> [Element] {
        return filter { $0 != object }
    }
}

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}


extension NSURL {
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
        let components = extractURLComponents(url: self)
        queryStrings.update(other: components)
        return queryStrings
    }
}



