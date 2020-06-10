//
//  UIVIew + Extention.swift
//  Converter Lab
//
//  Created by Albert on 03.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get{
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var isRounded: Bool {
        get {
            return true
        }
        set {
            cornerRadius = min(frame.width, frame.height)
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}
