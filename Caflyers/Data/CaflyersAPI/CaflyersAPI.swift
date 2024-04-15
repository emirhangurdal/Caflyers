//
//  CaflyersAPI.swift
//  Caflyers
//
//  Created by Emir Gurdal on 17.02.2024.
//

import Foundation

class CaflyersAPI {
    
    func getData(url: String, completion: @escaping (Data) -> Void) {
        let urlcheckString = url.replacingOccurrences(of: " ", with: "%20")
        
        guard let url = URL(string: urlcheckString) else {
          
            return}
        
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
            }
//          print(String(data: data, encoding: .utf8)!)
       
            completion(data)
            
        }
        task.resume()
    }
}
