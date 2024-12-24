//
//  StringExtension.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-19.
//

import UIKit

extension String {
    func heightWithConstraintWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        return ceil(boundingBox.height)
    }
}
