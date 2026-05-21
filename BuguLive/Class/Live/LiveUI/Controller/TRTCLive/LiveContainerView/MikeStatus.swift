//
//  MikeStatus.swift
//  BuguLive
//
//  Created by 志刚杨 on 2020/11/16.
//  Copyright © 2020 xfg. All rights reserved.
//

import UIKit

class MikeStatus: NSObject {
    @objc static let sharedInstance = MikeStatus()
    private override init() {}
    
    var list = [String:Bool]()
    
    func resetData()
    {
        list.removeAll()
    }
    
    @objc func setMute(byUserId userID:String,mute:Bool) {
        list[userID] = mute
    }
    
    @objc func getMute(byUserId userID:String) -> Bool {
        return list[userID] ?? false
    }
}
