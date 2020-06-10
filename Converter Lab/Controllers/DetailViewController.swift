//
//  DatailViewController.swift
//  Converter Lab
//
//  Created by Albert on 02.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit


final class DetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak private var sharedButton: UIBarButtonItem!
    @IBOutlet private var popOverView: UIView!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var myTableView: UITableView!
    @IBOutlet weak private var mapButton: UIButton!
    @IBOutlet weak private var linkButton: UIButton!
    @IBOutlet weak private var callButton: UIButton!
    @IBOutlet weak private var popOverTable: UITableView!
    @IBOutlet weak private var settingButton: UIButton!
    @IBOutlet weak private var mapLabel: UILabel!
    @IBOutlet weak private var linkLabel: UILabel!
    @IBOutlet weak private var callLabel: UILabel!
    
    //MARK: - Variable
    var userDefaultsOrganization: Organizations?
    var organization: Organizations?
    var massage = ""
    var activityController: UIActivityViewController?
    
    //MARK: Live cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        popOverTableView()
        buttonShadow(button: settingButton, color: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1))
        buttonShadow(button: mapButton, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        buttonShadow(button: linkButton, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        buttonShadow(button: callButton, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
    }
    
    // MARK: - Private functions
    private func courses(indexPath: Int) -> (buy: String, sale: String, name: String) {
        var name: String?
        var curs: [String: String]?
        var buy: String?
        var sale: String?
        
        for (index, key) in organization!.currencies.keys.enumerated() {
            if index == indexPath - 1 {
                name = "\(key)"
                curs = organization?.currencies[key]
                buy = curs?["bid"] ?? "0.0"
                sale = curs?["ask"] ?? "0.0"
                let saleDouble = Double(sale ?? "0.0")
                let buyDouble = Double(buy ?? "0.0")
                sale = String(format: "%.2f", saleDouble ?? 0.0)
                buy = String(format: "%.2f", buyDouble ?? 0.0)
            }
        }
        return (buy!, sale!, name!)
    }
    
    private func buttonShadow(button: UIButton , color: CGColor) {
        button.layer.shadowColor = color
        button.layer.shadowRadius = 5.0
        button.layer.shadowOpacity = 1.6
        button.layer.shadowOffset = CGSize(width: 5.0, height: 2.0)
        button.layer.masksToBounds = false
    }
    
    private func popOverTableView() {
        popOverTable.register(UINib(nibName: "NameBankAndAddressCell", bundle: nil), forCellReuseIdentifier: "NameBankAndAddressCell")
        popOverTable.register(UINib(nibName: "DisplayCourseInPopover", bundle: nil), forCellReuseIdentifier: "DisplayCourseInPopover")
        popOverTable.dataSource = self
    }
    
    private func setupTableView() {
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.register(UINib(nibName: "DetailOrganization", bundle: nil), forCellReuseIdentifier: "DetailOrganization")
        myTableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        myTableView.register(UINib(nibName: "TableForTheCourse", bundle: nil), forCellReuseIdentifier: "TableForTheCourse")
        myTableView.dataSource = self
    }
    
    private func isHiddenButtonAndLabel() {
        mapButton.isHidden = !mapButton.isHidden
        linkButton.isHidden = !linkButton.isHidden
        callButton.isHidden = !callButton.isHidden
        closeButton.isHidden = !closeButton.isHidden
        settingButton.isHidden = !settingButton.isHidden
        linkLabel.isHidden = !linkLabel.isHidden
        callLabel.isHidden = !callLabel.isHidden
        mapLabel.isHidden = !mapLabel.isHidden
        myTableView.isUserInteractionEnabled = !myTableView.isUserInteractionEnabled
    }
    
    // MARK: - IBActions
    @IBAction func mapButtonActions(_ sender: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else {return}
        guard let address = organization?.address else { return }
        vc.address = address
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func linkButtonAction(_ sender: UIButton!) {
        DataManager.dataManager.linksOfSafari(url: organization!)
    }
    
    @IBAction func callButtonAction(_ sender: UIButton!) {
        DataManager.dataManager.callOfNumber(number: organization!)
    }
    
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        popOverView.removeFromSuperview()
        myTableView.alpha = 1
        settingButton.isHidden = !settingButton.isHidden
        sharedButton.isEnabled = !sharedButton.isEnabled
    }
    
    @IBAction func sharedButtonAction(_ sender: UIButton) {
        activityController = UIActivityViewController(activityItems: [massage], applicationActivities: nil)
        present(activityController!, animated: true, completion: nil)
        self.popOverView.removeFromSuperview()
        myTableView.isUserInteractionEnabled = !myTableView.isUserInteractionEnabled
        myTableView.alpha = 1
        settingButton.isHidden = !settingButton.isHidden
        sharedButton.isEnabled = !sharedButton.isEnabled
    }
    
    @IBAction func sharedNavigationAction(_ sender: UIBarButtonItem) {
        view.addSubview(popOverView)
        self.popOverView.center = view.center
        popOverView.frame = CGRect(x: 20, y: 100, width: view.bounds.width - 35, height: view.bounds.height / 1.5)
        popOverTableView()
        myTableView.isUserInteractionEnabled = !myTableView.isUserInteractionEnabled
        myTableView.alpha = 0.2
        settingButton.isHidden = !settingButton.isHidden
        sharedButton.isEnabled = !sharedButton.isEnabled
        
    }
    
    @IBAction private func closeButtonAction(_ sender: UIButton) {
        isHiddenButtonAndLabel()
        myTableView.alpha = 1.0
        sharedButton.isEnabled = !sharedButton.isEnabled
    }
    
    @IBAction private func settingsButtonAction(_ sender: UIButton) {
        isHiddenButtonAndLabel()
        myTableView.alpha = 0.2
        sharedButton.isEnabled = !sharedButton.isEnabled
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == myTableView {
            return 3
        } else {
            return organization!.currencies.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == myTableView {
            switch indexPath.row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailOrganization", for: indexPath) as? DetailOrganization {
                    cell.nameBankLabel.text = organization?.title
                    if let number = organization?.phone {
                        cell.numberLabel.text = "Телефон: \(number)"
                    }
                    cell.linkOfBankLabel.text = "Официальный сайт: \n\(organization?.link ?? "")"
                    cell.streetLabel.text = "Адрес: \(organization?.address ?? "")"
                    return cell
                }
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as? HeaderCell {
                    return cell
                }
            case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TableForTheCourse", for: indexPath) as? TableForTheCourse {
                    cell.currencies = organization?.currencies
                    if let user = userDefaultsOrganization?.currencies {
                        cell.userDefaultCurrencies = user
                    }
                    return cell
                }
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "NameBankAndAddressCell", for: indexPath) as?  NameBankAndAddressCell {
                    cell.nameBankLabel.text = organization?.title
                    let region = DataManager.dataManager.infoBank.regions["\(organization?.regionId ?? "")"]
                    let city = DataManager.dataManager.infoBank.cities["\(organization?.cityId ?? "")"]
                    cell.regionsBankLabel.text = region
                    cell.CityBankLabel.text = city
                    self.massage.append(contentsOf: "Region: \(region!), City: \(city!)")
                    return cell
                }
            default:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayCourseInPopover", for: indexPath) as? DisplayCourseInPopover {
                    let cours = courses(indexPath: indexPath.row)
                    cell.nameCurs.text = cours.name
                    cell.priceLabel.text = "\(cours.buy)/\(cours.sale)"
                    self.massage.append(contentsOf: "\(cours.name) buy = \(cours.buy), sale = \(cours.sale)")
                    return cell
                }
                break
            }
        }
        return UITableViewCell()
    }
}
