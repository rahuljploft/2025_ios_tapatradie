//
//  Box.swift
//  Common
//
//  Created by Aman Maharjan on 24/09/2021.
//

import Foundation

public final class Box<T> {
    
    public typealias Listener = (T) -> Void
    public var listener: Listener?
    
    public var value: T {
        didSet { listener?(value) }
    }
    
    public init(_ value: T) { self.value = value }
    
    public func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
}
