//
//  LiveContainerCell.swift
//  BuguLive
//
//  Created by 志刚杨 on 2020/11/5.
//  Copyright © 2020 xfg. All rights reserved.
//

import UIKit
import Then
import SnapKit
import AutoInch
class LiveContainerCell: UICollectionViewCell,ClassIdentifiable {
    static var reuseId = "LiveContainerCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        self.configureAll()
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configureAll() {
        self.addSubview(imgBack);
        self.imgBack.addSubview(self.imgSofa)
        self.addSubview(self.videoView)
        self.addSubview(self.labUserName)
        self.addSubview(self.labCoin)
        self.addSubview(self.imgCoin)
    }

    func configureLayout() {

        self.labUserName.snp.makeConstraints{make in
            make.bottom.equalTo(self).inset(9.auto())
            make.left.equalTo(self).inset(8.auto())
        }
        self.videoView.snp.makeConstraints{make in
            make.edges.equalTo(self)
        }

        self.imgBack.snp.makeConstraints{ make in
            make.edges.equalTo(self)
        }

        self.imgCoin.snp.makeConstraints { make in
            make.bottom.equalTo(self).inset(9.5.auto());
            make.right.equalTo(self).inset(8.5.auto())
            make.size.equalTo(CGSize(width: 12, height: 11).auto())
        }
        
        self.imgCoin.isHidden = true

        self.labCoin.snp.makeConstraints { make in
            make.centerY.equalTo(self.imgCoin)
            make.right.equalTo(self.imgCoin.snp_left).offset(-2.5.auto())
        }
        
        self.labCoin.isHidden = true

        self.imgSofa.snp.makeConstraints{make in
            make.center.equalTo(self.imgBack)
            make.height.equalTo(22.auto())
            make.width.equalTo(22.auto())
        }


    }

    override func layoutIfNeeded() {

    }

    func bind(to model:LiveContainerCellModel)
    {
        
        
        self.labUserName.text = (model.number + "  " + (model.userName ?? "")).decodeEmoji!;
        self.labCoin.text = model.coin ?? "0"
    }


    
    var labUserName = UILabel().then{
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 12)
    }

    var imgSofa = UIImageView().then{
        $0.image = UIImage(named: "sofa")
        $0.contentMode = ContentMode.scaleAspectFit
    }

    var imgBack = UIImageView().then{
        $0.image = UIImage(named: "多人房间背景")
    }

    var videoView = UIView().then{
        $0.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
        $0.backgroundColor = .clear
    }



    var labCoin = UILabel().then
    {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .white
    }

    var imgCoin = UIImageView().then {
        $0.image = UIImage(named: "com_diamond_1")
        $0.contentMode = ContentMode.scaleAspectFit
    }


}

extension String {
    var decodeEmoji: String? {
      let data = self.data(using: String.Encoding.utf8,allowLossyConversion: false);
      let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
      if decodedStr != nil{
        return decodedStr as String?
    }
      return self
}
}
