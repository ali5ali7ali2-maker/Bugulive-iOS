//
//  UIEdgeInset+Extension.swift
//  TitleImageEdgeinsetsButton
//
//  Created by chunxi on 2019/1/10.
//  Copyright © 2019 chunxi. All rights reserved.
//

import UIKit

internal extension UIEdgeInsets {
    mutating func updateLeftAndRight(left: CGFloat) {
        self.left = left
        self.right = -left
    }

    mutating func updateTopAndBottom(top: CGFloat) {
        self.top = top
        self.bottom = -top
    }
}

