//
//  Equatable+IsAnyOf.swift
//  MapWidgetExtension
//
//  Created by Felix Mau on 15.10.20.
//

import Foundation

extension Equatable {
    func isAny(of candidates: Self...) -> Bool {
        candidates.contains(self)
    }
}
