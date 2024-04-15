//
//  HideKeyboard.swift
//  Caflyers
//
//  Created by Emir Gurdal on 3.03.2024.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}




