//
//  AsyncSequenceEmitter.swift
//  ConcurrencyUtility
//
//  Created by Oh Sangho on 2/22/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

public struct AsyncSequenceEmitter<T>: AsyncSequence {
    public typealias Element = T
    public typealias AsyncIterator = AsyncStream<T>.Iterator

    private let stream: AsyncStream<T>

    public init(values: [T]) {
        stream = AsyncStream { continuation in
            Task {
                for value in values {
                    continuation.yield(value)
                }
                continuation.finish()
            }
        }
    }

    public func makeAsyncIterator() -> AsyncIterator {
        stream.makeAsyncIterator()
    }
}
