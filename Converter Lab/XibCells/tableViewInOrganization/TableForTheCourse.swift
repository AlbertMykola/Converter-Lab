//
//  ThreeCell.swift
//  Converter Lab
//
//  Created by Albert on 02.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

final class TableForTheCourse: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variable
    var currencies: [String: [String: String]]?
    var userDefaultCurrencies: [String: [String: String]]?
    
    //MARK: - Live cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NameAndCourses", bundle: nil), forCellReuseIdentifier: "NameAndCourses")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK: - Private functions
    private func courses(indexPath: Int) -> (name: String, buy: String, sale: String) {
        var curs: [String: String]?
        var sale: String?
        var buy: String?
        var name: String?
        
        for (index, key) in currencies!.keys.enumerated() {
            if index == indexPath {
                name = DataManager.dataManager.infoBank.currencies["\(key)"]
                curs = currencies?["\(key)"]
                sale = curs?["ask"]
                buy = curs?["bid"]
                let sales = Double(sale ?? "0.0")
                let buys = Double(buy ?? "0.0")
                sale = String(format: "%.2f", sales ?? 0.0)
                buy = String(format: "%.2f", buys ?? 0.0)
            }
        }
        return (name!, buy!, sale!)
    }
    
    private func calculation(indexPath: Int, coursesBuy: Float, coursesSale: Float) -> (imageBuy: UIImage?, imageSale: UIImage?) {
        var imageBuy: UIImage?
        var imageSale: UIImage?
        
        for (index, key) in userDefaultCurrencies!.keys.enumerated() {
            if index == indexPath {
                let courses = userDefaultCurrencies![key]
                let userDefaultsSale = Float(courses!["ask"]!)
                let userDefaultsBuy = Float(courses!["bid"]!)
                
                if userDefaultsSale ?? 0.0 > coursesSale {
                    imageSale = UIImage(named: "bottom")
                } else {
                    imageSale = UIImage(named: "top")
                }
                
                if userDefaultsBuy ?? 0.0 > coursesBuy {
                    imageBuy = UIImage(named: "bottom")
                } else {
                    imageBuy = UIImage(named: "top")
                }
            }
        }
        return (imageBuy, imageSale)
    }
}

//MARK: - UITableViewDataSource
extension TableForTheCourse: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  currencies?.keys.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NameAndCourses", for: indexPath) as? NameAndCourses {
            
            let cours = courses(indexPath: indexPath.row)
            cell.saleLabel.text = cours.sale
            cell.buyLabel.text = cours.buy
            cell.nameLabel.text = cours.name
            
            if userDefaultCurrencies != nil {
                let image = calculation(indexPath: indexPath.row, coursesBuy: Float(cours.buy) ?? 0.0, coursesSale: Float(cours.sale) ?? 0.0)
                
                cell.myImageViewTwo.image = image.imageSale
                cell.myImageViewTwo.isHidden = false
                cell.myImageView.image = image.imageBuy
                cell.myImageView.isHidden = false
            }
            return cell
        }
        return UITableViewCell()
    }
}

