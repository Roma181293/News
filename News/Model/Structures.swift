//
//  Structures.swift
//  News
//
//  Created by Roman Topchii on 19.05.2020.
//  Copyright © 2020 Roman Topchii. All rights reserved.
//

import Foundation

struct NewsData : Decodable {
    var copyright: String
    var numResults: Int
    var results: [Article]
    var status: String
    
    enum CodingKeys : String, CodingKey {
    case copyright
    case numResults = "num_results"
    case results
    case status
    }
}

struct Article : Decodable {
    var abstract: String
    var adxKeywords: String
    var assetId: Int
    var byline: String
    var column: String?
//    var countType: String
    var desFacet : [String]
//    var emailCount: Int
    var etaId: Int
    var geoFacet: [String]
    var id: Int
    var media: [Media]
    var nytdsection: String
    var orgFacet: [String]
    var perFacet: [String]
    var publishedDate: String
    var section: String
    var source: String
    var subsection: String
    var title: String
    var type: String
    var updated: String
    var uri: String
    var url: String
    
    enum CodingKeys : String, CodingKey {
        case abstract
        case adxKeywords = "adx_keywords"
        case assetId = "asset_id"
        case byline
        case column
//        case countType = "count_type"
        case desFacet = "des_facet"
//        case emailCount = "email_count"
        case etaId = "eta_id"
        case geoFacet = "geo_facet"
        case id
        case media
        case nytdsection
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case publishedDate = "published_date"
        case section
        case source
        case subsection
        case title
        case type
        case updated
        case uri
        case url
    }
}


struct Media: Decodable {
//    var approvedForSyndication : Bool
    var caption: String
    var copyright: String
    var mediaMetaData: [MediaMetaData]
    var subtype: String
    var type: String

    enum CodingKeys: String, CodingKey {
//      case approvedForSyndication = "approved_for_syndication"
      case caption
      case copyright
      case mediaMetaData = "media-metadata"
      case subtype
      case type
    }
}

struct MediaMetaData: Decodable {
  var url: String
  var format: String
  var height: Int
  var width: Int
}
