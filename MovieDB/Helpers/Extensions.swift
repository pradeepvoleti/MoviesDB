//
//  Extensions.swift
//  MovieDB
//
//  Created by Ram Voleti on 28/02/21.
//

import Foundation

extension Encodable {
    var toData: Data? {
        return try? JSONEncoder().encode(self)
    }
}
