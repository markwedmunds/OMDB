//
//  omdbService.swift
//  OMDB
//
//  Created by Mark Edmunds on 21/11/2020.
//  Copyright © 2020 Mark Edmunds. All rights reserved.
//

import Foundation
import Alamofire

typealias OMDBServiceSearchResponse = (OMDBRecords?) -> Void

enum OMDBServiceError: Error {
    case invalidURL
}

protocol OMDBService {
  func searchMovieByTitle(title: String, onCompletion: @escaping OMDBServiceSearchResponse) throws
}

class OMDBServiceImpl: OMDBService {
  var apiUrl: String = "https://www.omdbapi.com/"
  var apiKey: String = "abc123"
  
  func searchMovieByTitle(title: String, onCompletion: @escaping OMDBServiceSearchResponse) throws {
    let searchQuery = try! buildQueryString(title: title)
    
    AF.request("\(apiUrl)\(searchQuery)")
      .validate()
      .responseDecodable(of: OMDBRecords.self) { (response) in
        guard let records = response.value else { return }
        onCompletion(records)
      }
  }
  
  func buildQueryString(title: String) throws -> String {
    var query = "?apikey=\(apiKey)"
    query += "&s=\(title)"
    query += "&r=json"
    
    if let encodedUrl = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
      return encodedUrl
    } else {
      throw OMDBServiceError.invalidURL
    }
  }
}
