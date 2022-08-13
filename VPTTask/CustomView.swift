//
//  CustomView.swift
//  VPTTask
//
//  Created by iOS on 12/08/22.
//

import Foundation
import UIKit
@IBDesignable class CustomView:UIView{
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet{
            return layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var shadowRadius:CGFloat = 0.0 {
        didSet{
            return layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable var shadowOpacity:Float = 0.0 {
        didSet{
            return layer.shadowOpacity = shadowOpacity
        }
    }
    @IBInspectable var shadowOffset:CGSize = .zero {
        didSet{
            return layer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable var shadowColor:UIColor = UIColor.clear {
        didSet{
            return layer.shadowColor = shadowColor.cgColor
        }
    }
    @IBInspectable var borderColor:UIColor = UIColor.clear {
        didSet{
            return layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet{
            return layer.borderWidth = borderWidth
        }
    }
}
