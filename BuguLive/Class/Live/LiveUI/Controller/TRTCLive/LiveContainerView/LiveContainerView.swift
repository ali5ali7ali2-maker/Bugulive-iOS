//
//  LiveContainerView.swift
//  BuguLive
//
//  Created by 志刚杨 on 2020/11/5.
//  Copyright © 2020 xfg. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import DynamicColor
enum LiveContainerViewType {
    case LiveContainerViewType4
    case LiveContainerViewType6
    case LiveContainerViewType9

    var count:Int{
        switch self{
        case .LiveContainerViewType4:
            return 4
        case .LiveContainerViewType6:
            return 6
        case .LiveContainerViewType9:
            return 9
        }
    }
}
//@objc(LiveContainerViewDelegate)
//@objc protocol  LiveContainerViewDelegate{
//    func liveContainerViewSelectItem(_ model:LiveContainerCellModel)
//}

@objc(LiveContainerViewDelegate)
protocol LiveContainerViewDelegate {
    func liveContainerViewSelectItem(_ model: LiveContainerCellModel)
    func liveContainerViewNeedReload()
}

class LiveContainerView: UIView {

    @objc var delegate:LiveContainerViewDelegate?
    var collectionView:UICollectionView!
    var type:LiveContainerViewType!
    var viewModel:LiveContainerViewModel?
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<CollectionsSectionModel>!
    typealias CollectionsSectionModel = SectionModel<String, LiveContainerCellModel>
    let disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        self.configureAll()
    }

    init(frame: CGRect,by type:LiveContainerViewType){
        super.init(frame: frame)
        self.backgroundColor = UIColor(hexString: "#262427")


        self.configureCollectionView(by: type)
        self.configureLayout()
    }

    func needRefresh() {
//        self.delegate?.liveContainerViewNeedRefresh()
    }
    
    func configureAll() {


    }
    
    @objc func updateData(_ userList:[LiveContainerCellModel])
    {
        self.viewModel?.input.reloadData(userList)
    }
    
    @objc func hasUser(userId:String)->Bool{
        if(self.viewModel?.output.listData.count == 0)
        {
            return false;
        }
        for user in self.viewModel!.output.listData {
            if(user.userId == userId)
            {
                return true;
            }
        }
        
        return false;
    }
    
    private func configureCollectionView(by type:LiveContainerViewType) {
        self.type = type
        self.viewModel = LiveContainerViewModel(byType: type)

        let flowLayout = getFlowLayout(by: type)
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
//        collectionView.isHidden = true
        collectionView.backgroundColor = UIColor(hexString: "#262427")
        self.addSubview(collectionView)

        collectionView.register(cellType: LiveContainerCell.self)
//        collectionView.register(cellType: BioTreeCollectionViewCell.self)
        dataSource = RxCollectionViewSectionedReloadDataSource<CollectionsSectionModel>(
                configureCell:  collectionViewDataSource
        )
        collectionView.rx.modelSelected(LiveContainerCellModel.self)
            .subscribe(onNext:{item in
                print("选中了\(item.userName ?? "xx")")
                self.delegate?.liveContainerViewSelectItem(item)
            }).disposed(by: disposeBag)

        self.viewModel?.output.roomListPush.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }


    func getFlowLayout(by type:LiveContainerViewType )-> UICollectionViewFlowLayout
    {
        switch type{
        case .LiveContainerViewType9:
            let flowLayout = UICollectionViewFlowLayout()

            let spacing:CGFloat = 0.25
            let cellWidth = CGFloat((UIScreen.main.bounds.width / 3)) - spacing * 3

            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0.5, bottom: 0, right: 0.5)
            flowLayout.minimumLineSpacing = spacing
            flowLayout.minimumInteritemSpacing = spacing
            return flowLayout
        case .LiveContainerViewType4:

            let flowLayout = UICollectionViewFlowLayout()

            let spacing:CGFloat = 0.25
            let cellWidth = CGFloat((UIScreen.main.bounds.width / 2)) - spacing * 4

            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0.5, bottom: 0, right: 0.5)
            flowLayout.minimumLineSpacing = spacing
            flowLayout.minimumInteritemSpacing = spacing
            return flowLayout

        case .LiveContainerViewType6:
            let flowLayout = LiveContainerFlowLayout_6()

            let spacing:CGFloat = 0.25
            let cellWidth = CGFloat((UIScreen.main.bounds.width / 2)) - spacing * 4

            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0.5, bottom: 0, right: 0.5)
            flowLayout.minimumLineSpacing = spacing
            flowLayout.minimumInteritemSpacing = spacing
            return flowLayout
        default:
            return UICollectionViewFlowLayout()
        }

    }
    private var collectionViewDataSource: CollectionViewSectionedDataSource<CollectionsSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell: LiveContainerCell = self.collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.bind(to: cellModel)
            if(indexPath.item == 0)
            {
                cell.backgroundColor = .gray
            }
            return cell
        }
    }

//    func getContentView(byUserId userID:String)->UIView
//    {
//
//    }

    //注意，如果是在type9的情况下，获取主播的视图是仍然传0，并不是1
    func getUserContentView(byUserIndex Index:Int)->UIView
    {
        let cureIndex = Index
//        if(self.type == .LiveContainerViewType9)
//        {
//            if(Index == 0)
//            {
//                cureIndex = 1
//            }
//            if(Index == 1)
//            {
//                cureIndex = 0
//            }
//        }
        let indexPath = IndexPath(item: cureIndex, section: 0)
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? LiveContainerCell else {
            return UIView()
        }

        return cell.videoView
    }

    func configureLayout() {

    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
