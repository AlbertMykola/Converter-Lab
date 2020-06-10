//
//  TableViewCell.swift
//  Converter Lab
//
//  Created by Albert on 01.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit



protocol TestTableViewCellDelegate: class {
    
    func didTapedButton(from cell: CellAllInfoInOrganization)
}

class CellAllInfoInOrganization: UITableViewCell {
    
    //MARK: - Private outlets
    @IBOutlet private var viewCell: UIView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var regionLabel: UILabel!
    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var phoneLabel: UILabel!
    @IBOutlet weak private var streetLabel: UILabel!
    @IBOutlet weak private var buttonOutlet: UIButton!
    
    //MARK: - Variable
    weak var delegate: TestTableViewCellDelegate? = nil
    var tags: Int?
    
    //MARK: - Live cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = buttonOutlet.imageView?.image?.withRenderingMode(.alwaysTemplate)
        buttonOutlet.setImage(image, for: .normal)
        buttonOutlet.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.2158794086, alpha: 1)

        self.viewCell.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.viewCell.layer.shadowRadius = 4.0
        self.viewCell.layer.shadowOpacity = 0.6
        self.viewCell.layer.shadowOffset = CGSize(width: 1.0, height: 4.0)
    }
    
    //MARK: - Functions
    func setupCell(param: Organizations) {
        nameLabel.text = param.title!
        phoneLabel.text = "Тел: \(param.phone ?? "")"
        streetLabel.text = "\(param.address ?? "")"
        regionLabel.text = "\(param.region ?? "")"
        cityLabel.text = "\(param.city ?? "")"
    }
    
    //MARK: - Actions
    @IBAction private func buttonAction(_ sender: UIButton) {
        tags = sender.tag

        delegate?.didTapedButton(from: self)
    }
}
