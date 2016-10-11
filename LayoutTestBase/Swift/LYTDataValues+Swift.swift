//
//  LYTDataValues+Swift.swift
//  LayoutTest
//
//  Created by Peter Livesey on 9/30/16.
//  Copyright © 2016 LinkedIn. All rights reserved.
//

import Foundation

extension DataValues {
    /**
     Returns LYTDataValues with these specific values and overrides any subclass's behavior.
     This function converts all nil values to NSNull which is what the library expects.
     These will be represented as empty entries in the dictionary.
     */
    public convenience init(values: [Any?]) {
        let array: [Any] = values.map { value in
            if let value = value {
                return value
            } else {
                return NSNull()
            }
        }
        self.init(__values: array)
    }
}
