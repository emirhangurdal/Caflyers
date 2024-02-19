//
//  Parse.swift
//  Caflyers
//
//  Created by Emir Gurdal on 17.02.2024.
//

import Foundation

class Parse {
    func parseJson<T: Codable>(data: Data, completionHandler: @escaping (T) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            
            completionHandler(decodedData)
            
        } catch {
            print("error ParseData = \(error.localizedDescription)")
            print("error ParseData = \(error)")
        }
    }
}
