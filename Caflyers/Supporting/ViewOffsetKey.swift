//
//  ViewOffsetKey.swift
//  Caflyers
//
//  Created by Emir Gurdal on 2.03.2024.
//

import Foundation
import SwiftUI
import Combine

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
