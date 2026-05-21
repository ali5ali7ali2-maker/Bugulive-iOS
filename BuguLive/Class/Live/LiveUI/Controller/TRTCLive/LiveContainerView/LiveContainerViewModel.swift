//
// Created by 志刚杨 on 2020/11/6.
// Copyright (c) 2020 xfg. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias CollectionsSectionModel = SectionModel<String, LiveContainerCellModel>

protocol LiveContainerViewModelInput {
    func reloadData(_ userList:[LiveContainerCellModel])
}

protocol LiveContainerViewModelOutput {
    var roomListPush:BehaviorRelay<[CollectionsSectionModel]>{get}
    var listData:[LiveContainerCellModel]! { get }
}

protocol LiveContainerViewModelType {
    var output:LiveContainerViewModelOutput{get}
    var input:LiveContainerViewModelInput{get}
}

class LiveContainerViewModel:LiveContainerViewModelInput,LiveContainerViewModelOutput,LiveContainerViewModelType {
    var roomListPush = BehaviorRelay<[CollectionsSectionModel]>(value: [])
    var output:LiveContainerViewModelOutput {return self}
    var input:LiveContainerViewModelInput {return self}
    var roomType:LiveContainerViewType?
    var listData:[LiveContainerCellModel]!

    init(byType type:LiveContainerViewType) {
        var roomList:[LiveContainerCellModel] = []
        for index in 0...type.count - 1
        {
            let model = LiveContainerCellModel()
            self.roomType = type
            model.userName = ""
            if(index == 0)
            {
                model.userName = "Host"
            }
            model.number = String(index + 1)
            model.coin = ""
            roomList.append(model)
        }
        self.listData = roomList
        let arr = [CollectionsSectionModel(model: "", items: roomList)]
        self.roomListPush.accept(arr)
    }
    
    func reloadData(_ userList: [LiveContainerCellModel]) {
        var roomList:[LiveContainerCellModel] = []
        if(self.roomType == nil)
        {
            return
        }
        for index in 0...self.roomType!.count - 1
        {
            
            let item =  getItem(number: String((index + 1)), arr: userList)
            if((item) != nil)
            {
                roomList.append(item!)
            }
            else{
                let model = LiveContainerCellModel()
                model.userName = ""
                if(index == 0)
                {
                    model.userName = "Host"
                }
                model.number = String(index + 1)
                model.coin = ""
                roomList.append(model)
            }

        }
        
      
        
        self.listData = roomList
        let arr = [CollectionsSectionModel(model: "", items: roomList)]
        self.roomListPush.accept(arr)
        
        
    }
    
    func getItem(number:String,arr:[LiveContainerCellModel]) -> LiveContainerCellModel? {
        for item in arr {
            if(item.number == number)
            {
                return item
            }
            
        }
        
        return nil
    }
}
