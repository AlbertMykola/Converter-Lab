//
//  Organizations.swift
//  Converter Lab
//
//  Created by Albert on 01.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import Foundation

struct Model: Decodable, Encodable {
    var organizations: [Organizations?]?
    var regions = [String: String]()
    var cities = [String: String]()
    var currencies = [String: String]()    
}

class Organizations: Decodable, Encodable {
    var title: String?
    var regionId: String?
    var cityId: String?
    var phone: String?
    var address: String?
    var link: String?
    var region: String?
    var city: String?
    var currencies: [String: [String: String]]
}


