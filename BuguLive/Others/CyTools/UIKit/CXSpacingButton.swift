//
//  CXSpacingButton.swift
//  TitleImageEdgeinsetsButton
//
//  Created by chunxi on 2019/1/10.
//  Copyright © 2019 chunxi. All rights reserved.
//

import UIKit

/*
 默认的图片在左文字在右侧
 */

public enum ImagePosition {
    case left
    case right
    case bottom
    case top
}

public class CXSpacingButton: UIButton {

    public var spacing: CGFloat = 0
    public var imagePosition: ImagePosition = .left

    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutImagePosition()
    }

    private func layoutImagePosition() {
        let content = super.contentRect(forBounds: bounds)
        let titleRect = super.titleRect(forContentRect: content)
        let imageRect = super.imageRect(forContentRect: content)
        print(content,titleRect,imageRect)
        switch imagePosition {
        case .left:
            switch contentHorizontalAlignment {
            case .center:
                titleEdgeInsets.updateLeftAndRight(left: spacing / 2)
                imageEdgeInsets.updateLeftAndRight(left: -spacing / 2)
            case .left:
                titleEdgeInsets.updateLeftAndRight(left: spacing)
                imageEdgeInsets.updateLeftAndRight(left: 0)
            case .right:
                titleEdgeInsets.updateLeftAndRight(left: 0)
                imageEdgeInsets.updateLeftAndRight(left: -spacing)
            default:
                break
            }
        case .right:
            var imageOffset = titleRect.width
            var titleOffset = imageRect.width
            switch contentHorizontalAlignment {
            case .center:
                imageOffset = imageOffset + spacing/2
                titleOffset = titleOffset + spacing/2
            case .left:
                imageOffset = imageOffset + spacing
            case .right:
                titleOffset = titleOffset + spacing
            default:
                break
            }
            imageEdgeInsets.updateLeftAndRight(left: imageOffset)
            titleEdgeInsets.updateLeftAndRight(left: -titleOffset)
        case .top:
            let allWidth = imageRect.width + titleRect.width
            let allHeight = imageRect.height + titleRect.height
            let maxHeight = max(imageRect.height, titleRect.height)
            switch contentHorizontalAlignment {
            case .center:
                let imageOffsetX = allWidth/2 - imageRect.width/2
                let titleOffsetX = allWidth/2 - titleRect.width/2
                imageEdgeInsets.updateLeftAndRight(left: imageOffsetX)
                titleEdgeInsets.updateLeftAndRight(left: -titleOffsetX)
            case .left:
                titleEdgeInsets.updateLeftAndRight(left: -imageRect.width)
                imageEdgeInsets.updateLeftAndRight(left: 0)
            case .right:
                titleEdgeInsets.updateLeftAndRight(left: 0)
                imageEdgeInsets.updateLeftAndRight(left: titleRect.width)
            default:
                break
            }
            switch contentVerticalAlignment {
            case .center:
                let baseHeight = allHeight - maxHeight
                let imageOffsetY = baseHeight/2 + spacing/2
                let titleOffsetY = baseHeight/2 + spacing/2
                imageEdgeInsets.updateTopAndBottom(top: -imageOffsetY)
                titleEdgeInsets.updateTopAndBottom(top: titleOffsetY)
            case .top:
                imageEdgeInsets.updateTopAndBottom(top: 0)
                titleEdgeInsets.updateTopAndBottom(top: imageRect.height + spacing)
            case .bottom:
                imageEdgeInsets.updateTopAndBottom(top: -titleRect.height - spacing)
                titleEdgeInsets.updateTopAndBottom(top: 0)
            default:
                break
            }

        case .bottom:
            let allWidth = imageRect.width + titleRect.width
            let allHeight = imageRect.height + titleRect.height
            let maxHeight = max(imageRect.height, titleRect.height)
            switch contentHorizontalAlignment {
            case .center:
                let imageOffsetX = allWidth/2 - imageRect.width/2
                let titleOffsetX = allWidth/2 - titleRect.width/2
                imageEdgeInsets.updateLeftAndRight(left: imageOffsetX)
                titleEdgeInsets.updateLeftAndRight(left: -titleOffsetX)
            case .left:
                titleEdgeInsets.updateLeftAndRight(left: -imageRect.width)
                imageEdgeInsets.updateLeftAndRight(left: 0)
            case .right:
                titleEdgeInsets.updateLeftAndRight(left: 0)
                imageEdgeInsets.updateLeftAndRight(left: titleRect.width)
            default:
                break
            }
            switch contentVerticalAlignment {
            case .center:
                let baseHeight = allHeight - maxHeight
                let imageOffsetY = baseHeight/2 + spacing/2
                let titleOffsetY = baseHeight/2 + spacing/2
                imageEdgeInsets.updateTopAndBottom(top: imageOffsetY)
                titleEdgeInsets.updateTopAndBottom(top: -titleOffsetY)
            case .top:
                imageEdgeInsets.updateTopAndBottom(top: titleRect.height + spacing)
                titleEdgeInsets.updateTopAndBottom(top: 0)
            case .bottom:
                imageEdgeInsets.updateTopAndBottom(top: 0)
                titleEdgeInsets.updateTopAndBottom(top: -imageRect.height - spacing)
            default:
                break
            }
        }
    }

}
