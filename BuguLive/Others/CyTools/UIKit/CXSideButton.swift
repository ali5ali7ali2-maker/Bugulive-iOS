//
//  CXAlignmentButton.swift
//  TitleImageEdgeinsetsButton
//
//  Created by chunxi on 2019/1/10.
//  Copyright © 2019 chunxi. All rights reserved.
//

import UIKit

/// 图片和标题处于相对方向且都贴在最近的一条边上
///
/// - left: 图片靠左侧边
/// - right: 图片靠右侧边
/// - top: 图片靠上侧边
/// - bottom: 图片靠下侧边
public enum ImageSideAlignment {
    case left(CGFloat, titleRight: CGFloat)
    case right(CGFloat, titleLeft: CGFloat)
    case top(CGFloat, titleBottom: CGFloat)
    case bottom(CGFloat,titleTop: CGFloat)
}


public class CXSideButton: UIButton {

    public var imageSideAlignment: ImageSideAlignment?

    override public func layoutSubviews() {
        super.layoutSubviews()
        if let sideAlignment = imageSideAlignment {
            layoutImageSideAlignment(sideAlignment)
        }
    }

    private func layoutImageSideAlignment(_ alignment: ImageSideAlignment) {
        guard contentHorizontalAlignment == .center, contentVerticalAlignment == .center else {
            fatalError("*** content horizon and vertical must be center")
        }
        let content = super.contentRect(forBounds: bounds)
        let titleSize = super.titleRect(forContentRect: content).size
        let imageSize = super.imageRect(forContentRect: content).size
        let imageAndTitleWidth = titleSize.width + imageSize.width
        switch alignment {
        case .left(let imageLeft, let titleRight):
            let offset = (bounds.width - imageAndTitleWidth)/2
            imageEdgeInsets.updateLeftAndRight(left: -offset + imageLeft)
            titleEdgeInsets.updateLeftAndRight(left: offset - titleRight)
        case .right(let imageRight, let titleLeft):
            let offset = (bounds.width - imageAndTitleWidth)/2
            imageEdgeInsets.updateLeftAndRight(left: offset + titleSize.width - imageRight)
            titleEdgeInsets.updateLeftAndRight(left: -offset - imageSize.width + titleLeft)
        case .top(let imageTop, let titleBottom):
            let allWidth = imageSize.width + titleSize.width
            let imageOffsetX = allWidth/2 - imageSize.width/2
            let titleOffsetX = allWidth/2 - titleSize.width/2
            imageEdgeInsets.updateLeftAndRight(left: imageOffsetX)
            titleEdgeInsets.updateLeftAndRight(left: -titleOffsetX)
            imageEdgeInsets.updateTopAndBottom(top: -content.height/2 + imageSize.height/2 + imageTop)
            titleEdgeInsets.updateTopAndBottom(top: content.height/2 - titleSize.height/2 - titleBottom)
        case .bottom(let imageBottom, let titleTop):
            let allWidth = imageSize.width + titleSize.width
            let imageOffsetX = allWidth/2 - imageSize.width/2
            let titleOffsetX = allWidth/2 - titleSize.width/2
            imageEdgeInsets.updateLeftAndRight(left: imageOffsetX)
            titleEdgeInsets.updateLeftAndRight(left: -titleOffsetX)
            imageEdgeInsets.updateTopAndBottom(top: content.height/2 - imageSize.height/2  - imageBottom)
            titleEdgeInsets.updateTopAndBottom(top: -content.height/2 + titleSize.height/2 + titleTop)
        }
    }
}
