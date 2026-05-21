//
//  OpenLiveTypePop.swift
//  BuguLive
//
//  Created by 志刚杨 on 2020/11/9.
//  Copyright © 2020 xfg. All rights reserved.
//

import UIKit
import SnapKit
import Then

@objc(OpenLiveTypePopDelegate)
protocol OpenLiveTypePopDelegate {
    func onSelectType(byType type: String,des:String)
}



class OpenLiveTypePop: UIView {
    var roomType = "4";
    var horizontalStackView:UIStackView!

    @objc var delegate: OpenLiveTypePopDelegate?

    lazy var btn_4 = UIButton().then {
//        $0.addTarget(self, action: #selector(btnEventHandler()), for: .touchUpInside)
        $0.frame = CGRect(x: 0, y: 0, width: 45.auto(), height: 70.auto())
        $0.setImage(UIImage(named:"simaiwei"), for: .normal)
        $0.imageView?.frame.size = CGSize(width: 45.auto(),height: 45.auto())
//        $0.setTitle("四麦位", for: .normal)
        $0.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)

    }

    lazy var btn_6 = UIButton().then {
//        $0.addTarget(self, action: #selector(btnEventHandler()), for: .touchUpInside)
        $0.frame = CGRect(x: 0, y: 0, width: 45.auto(), height: 70.auto())
        $0.setImage(UIImage(named:"liumaiwei"), for: .normal)

//        $0.setTitle("六麦位", for: .normal)
        $0.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)

    }

    lazy var btn_9 = UIButton().then {
//        $0.addTarget(self, action: #selector(btnEventHandler()), for: .touchUpInside)
        $0.frame = CGRect(x: 0, y: 0, width: 45.auto(), height: 70.auto())
        $0.setImage(UIImage(named:"simaiwei"), for: .normal)

//        $0.setTitle("九麦位", for: .normal)
        $0.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)


    }

    override init(frame: CGRect) {

        super.init(frame: frame)

        self.configureAll()
        self.configureLayout()
    }

    @objc func btnEventHandler(button:CustomImageTitleButton)
    {
        switch button
        {
        case self.btn_4:
            self.roomType = "4"
        case self.btn_6:
            self.roomType = "6"
        case self.btn_9:
            self.roomType = "9"

        default:
            self.roomType = "4"
        }

//        self.delegate?.onSelectType(byType: self.roomType)
    }

    lazy var btnArr = {
        return [self.btn_4,self.btn_6,self.btn_9]
    }()

    func configureAll() {

        self.layer.cornerRadius = 5.auto()
        self.layer.masksToBounds = true;
        if #available(iOS 11.0,*)
        {
            self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }

        for btn in self.btnArr
        {
            btn.addTarget(self, action: #selector(btnEventHandler(button:)), for: .touchUpInside)

        }

        self.horizontalStackView = UIStackView(arrangedSubviews: self.btnArr)
        self.horizontalStackView.spacing = 69.5.auto()
        self.horizontalStackView.axis = .horizontal
        self.horizontalStackView.alignment = .center
        self.horizontalStackView.distribution = .equalSpacing
        self.addSubview(self.horizontalStackView)
    }

    func configureLayout() {
        self.horizontalStackView.snp.makeConstraints{ maker in
            maker.width.equalTo(self).offset((-40*2).auto()) //两边间距
            maker.center.equalTo(self)
            maker.height.equalTo(self)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }






}
