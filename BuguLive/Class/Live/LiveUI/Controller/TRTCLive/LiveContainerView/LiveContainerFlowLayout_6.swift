//
//  LiveContainerFlowLayout_6.swift
//  BuguLive
//
//  Created by 志刚杨 on 2020/11/5.
//  Copyright © 2020 xfg. All rights reserved.
//

import UIKit

class LiveContainerFlowLayout_6: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let attrsArray = super.layoutAttributesForElements(in: rect)else { return [] }
        let  centerX = self.collectionView!.frame.size.width / 2 + self.collectionView!.contentOffset.x
        var loopIndex = 0

        var colWidth = UIScreen.main.bounds.width
        var firstCellWidth = colWidth/3*2-0.5;
        var smallCellWidth = firstCellWidth/2
        for attrs in attrsArray  {

            var width:CGFloat = 0.0;
            var x:CGFloat = 0.0;
            var y:CGFloat = 0.0;
            if(loopIndex == 0)
            {
                width = firstCellWidth
            }
            else
            {
                width = smallCellWidth
                switch loopIndex{
                case 1:
                    y = 0
                    x = firstCellWidth
                case 2:
                    y = firstCellWidth/2
                    x = firstCellWidth
                default:
                    y = firstCellWidth
                    x = CGFloat(loopIndex - 3) * smallCellWidth
                }

            }
            attrs.frame = CGRect(x: x,y: y,width: width,height: width)
            loopIndex += 1

        }
        return attrsArray;
    }
}
