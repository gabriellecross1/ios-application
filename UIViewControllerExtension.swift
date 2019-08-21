//
//  UIViewControllerExtension.swift
//  AssignmentOne
//
//  Created by Gabrielle on 03/01/2019.
//
//

import Foundation
import UIKit

extension UIViewController {
    
    func getColour() -> UIColor {
        
        let colour = UserDefaults.standard.string(forKey: "Colour") ?? ""
        
        if colour == "Orange" {
            return UIColor.orange
        } else if colour == "Blue" {
            return UIColor.blue
        } else if colour == "Green" {
            return UIColor.green
        } else {
            return UIColor.init(red: 0.5, green: 0.00, blue: 0.25, alpha: 1.0)
        }
    }
    
    func getBackgroundImage(id: Int) -> UIImage {
        
        let colour = UserDefaults.standard.string(forKey: "Colour") ?? ""
        
        if colour == "Orange" {
            if id == 0 {
                return UIImage(named: "orangebackground.png")!
            } else {
                return UIImage(named: "orangeSparkle.png")!
            }
        } else if colour == "Blue" {
            if id == 0 {
                return UIImage(named: "bluebackground.png")!
            } else {
                return UIImage(named: "blueSparkle.png")!
            }
        } else if colour == "Green" {
            if id == 0 {
                return UIImage(named: "greenBackground.png")!
            } else {
                return UIImage(named: "greenSparkle.png")!
            }
        } else {
            if id == 0 {
                return UIImage(named: "pinkBackground.png")!
            } else {
                return UIImage(named: "purpleSparkle.png")!
            }
            
        }
    }
}
