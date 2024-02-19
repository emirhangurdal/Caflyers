//
//  CaflyersAPI.swift
//  Caflyers
//
//  Created by Emir Gurdal on 17.02.2024.
//

import Foundation

class CaflyersAPI {
    
    func getData(url: String, completion: @escaping (Data) -> Void) {
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
           completion(data)
        }
        task.resume()
    }
}
