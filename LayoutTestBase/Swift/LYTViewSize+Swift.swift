//
//  LYTViewSize+Swift.swift
//  LayoutTest
//
//  Created by Peter Livesey on 9/30/16.
//  Copyright © 2016 LinkedIn. All rights reserved.
//

import Foundation

extension ViewSize {

    /**
     The width for the view. If nil, do not edit the width.
     */
    open var width: CGFloat? {
        get {
            return __width.flatMap { CGFloat( $0.floatValue ) }
        }
    }

    /**
     The height for the view. If nil, do not edit the height.
     */
    open var height: CGFloat? {
        get {
            return __height.flatMap {  CGFloat( $0.floatValue ) }
        }
    }

    /**
     Creates a view size which will either the width, height, or both.
     If width or height is set to nil, that dimension will not be changed.
     */
    public convenience init(width: CGFloat? = nil, height: CGFloat? = nil) {
        self.init(__width: width.flatMap { NSNumber(value: Double($0)) }, height: height.flatMap { NSNumber(value: Double($0)) })
    }
}
