//
//  UIScreenExtension.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-19.
//

import UIKit

extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
