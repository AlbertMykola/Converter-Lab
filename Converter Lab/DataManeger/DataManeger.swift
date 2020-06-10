//
//  DataManeger.swift
//  Converter Lab
//
//  Created by Albert on 03.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
    static var dataManager = DataManager()
    var infoBank = Model()
    
    func linksOfSafari(url: Organizations) {
        if let url = URL(string: url.link ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func callOfNumber(number: Organizations) {
        let url = NSURL(string: "telprompt://+38\(number.phone!)")!
        if UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}
