//
//  ViewController.swift
//  Converter Lab
//
//  Created by Albert on 01.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak private var search: UIBarButtonItem!
    
    // MARK: - Variables
    private var timer = Timer()
    var networkService = NetworkService()
    var dataSource = [Organizations?]()
    var filterArray = [Organizations?]()
    var userDefaultsOrganization: Model?
    var searching = false
    var url = "https://resources.finance.ua/ru/public/currency-cash.json"
    var searchController = UISearchController(searchResultsController: nil)
    
    
    //MARK: - Live cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCellMyTableView()
        networkService.request(urlString: url) { [weak self] (result) in
            switch result {
            case .success(let model):
                DataManager.dataManager.infoBank = model
                if let organization = model.organizations {
                    self?.dataSource = organization
                }
                self?.addRegionAndCity()
                self?.myTableView.reloadData()
            case .failure( _):
                if let networkService = NetworkService.shared.load(forKey: "infoBank") {
                    DataManager.dataManager.infoBank = networkService
                    if let organization =  networkService.organizations {
                        self?.dataSource = organization
                    }
                }
                self?.myTableView.reloadData()
            }
        }
        let infoBank = NetworkService.shared.load(forKey: "infoBank")
        if infoBank != nil {
            userDefaultsOrganization = infoBank
        }
    }
    
    //MARK: - Actions
    @IBAction private func searchAction(_ sender: UIBarButtonItem) {
        searchController.obscuresBackgroundDuringPresentation = false
        navigationController?.present(searchController, animated: true, completion: nil)
        searchController.searchBar.delegate = self
    }
    
    //MARK: - Functions
    private func setupCellMyTableView() {
        myTableView.dataSource = self
        myTableView.rowHeight = UITableView.automaticDimension
        
        myTableView.register(UINib(nibName: "CellAllInfoInOrganization", bundle: nil), forCellReuseIdentifier: "CellAllInfoInOrganization")
    }
    
    private func nextDetailVC(array: [Organizations?], indexPath: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        guard let organization = array[indexPath] else { return }
        vc.organization = organization
        if userDefaultsOrganization?.organizations != nil {
            let userOrganization = userDefaultsOrganization?.organizations
            if let user = userOrganization?[indexPath] {
                vc.userDefaultsOrganization = user
            }
        }
        myTableView.beginUpdates()
        searchController.isActive = false
        myTableView.endUpdates()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addRegionAndCity() {
        for index in 0..<dataSource.count {
            let region = DataManager.dataManager.infoBank.regions["\(dataSource[index]!.regionId!)"]
            let city = DataManager.dataManager.infoBank.cities["\(dataSource[index]!.cityId!)"]
            dataSource[index]?.city = city ?? ""
            dataSource[index]?.region = region ?? ""
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filterArray.count
        } else {
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellAllInfoInOrganization", for: indexPath) as! CellAllInfoInOrganization
        cell.delegate = self
        if searching {
            if let organizations = filterArray[indexPath.row] {
                cell.setupCell(param: organizations)
            }
            return cell
        } else {
            if let organizations = dataSource[indexPath.row] {
                cell.setupCell(param: organizations)
            }
            return cell
        }
    }
}

extension ViewController: TestTableViewCellDelegate {
    
    func didTapedButton(from cell: CellAllInfoInOrganization) {
        let indexPath = myTableView.indexPath(for: cell)
        
        switch cell.tags {
        case 0:
            DataManager.dataManager.linksOfSafari(url: (DataManager.dataManager.infoBank.organizations?[indexPath!.row])!)
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else {return}
            guard let address = DataManager.dataManager.infoBank.organizations?[indexPath!.row]?.address else { return }
            vc.address = address
            myTableView.beginUpdates()
            searchController.isActive = false
            myTableView.endUpdates()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            DataManager.dataManager.callOfNumber(number: (DataManager.dataManager.infoBank.organizations?[indexPath!.row])!)
        case 3:
            if searching {
                nextDetailVC(array: filterArray, indexPath: indexPath!.row)
                
            } else {
                nextDetailVC(array: dataSource, indexPath: indexPath!.row)
            }
        default:
            break
        }
    }
}

//MARK: - UISearchControllerDelegate
extension ViewController: UISearchControllerDelegate {
    func filter(searchText: String) {
        self.filterArray = self.dataSource.filter({ [weak self] (organization) -> Bool in
            if let isFilterName = organization?.title?.localizedCaseInsensitiveContains(searchText) {
                if isFilterName {
                    return true
                }
            }
            
            if let isFilterRegion = organization?.region?.localizedCaseInsensitiveContains(searchText) {
                if  isFilterRegion {
                    return true
                }
            }
            
            if let isFilterCity = organization?.city?.localizedCaseInsensitiveContains(searchText) {
                if isFilterCity {
                    return true
                }
            }
            return false
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self](_) in
            if searchText != "" {
                self?.filter(searchText: searchText)
                self?.searching = true
                self?.myTableView.reloadData()
            } else {
                self?.filterArray.removeAll()
                self?.searching = false
                self?.myTableView.reloadData()
            }
        })
    }
    
}

