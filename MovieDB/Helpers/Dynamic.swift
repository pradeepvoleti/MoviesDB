//
//  Dynamic.swift
//  MovieDB
//
//  Created by Ram Voleti on 28/02/21.
//

import Foundation

class Dynamic<T> {
    typealias Listener = (T) -> Void
    private var listener: Listener?

    func bind(_ listener: Listener?) {
        self.listener = listener
    }

    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    var value: T {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.listener?(weakSelf.value)
            }
        }
    }

    init(_ value: T) {
        self.value = value
    }
}
