//
//  OMDBRecord.swift
//  OMDB
//
//  Created by Mark Edmunds on 21/11/2020.
//  Copyright © 2020 Mark Edmunds. All rights reserved.
//

protocol Displayable {
  var titleLabelText: String { get }
  var subtitleLabelText: String { get }
  var item1: (label: String, value: String) { get }
  var imageUrl: String { get }
}

struct OMDBRecord: Decodable {
  let id: String
  let title: String
  let type: String
  let year: String
  let poster: String
  
  enum CodingKeys: String, CodingKey {
    case id = "imdbID"
    case title = "Title"
    case type = "Type"
    case year = "Year"
    case poster = "Poster"
  }
}

extension OMDBRecord: Displayable {
  var titleLabelText: String {
    title
  }
  
  var subtitleLabelText: String {
    "IMDB ID \(String(id))"
  }
  
  var item1: (label: String, value: String) {
    ("RELEASE DATE", year)
  }
  
  var imageUrl: String {
    poster
  }
}

