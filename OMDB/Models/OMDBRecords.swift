//
//  OMDBRecords.swift
//  OMDB
//
//  Created by Mark Edmunds on 21/11/2020.
//  Copyright © 2020 Mark Edmunds. All rights reserved.
//

struct OMDBRecords: Decodable {
  let totalResults: String
  let all: [OMDBRecord]
  
  enum CodingKeys: String, CodingKey {
    case totalResults
    case all = "Search"
  }
}

