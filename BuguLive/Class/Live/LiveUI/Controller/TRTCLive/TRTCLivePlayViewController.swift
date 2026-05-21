//
//  LivePlayViewController.swift
//  TRTCSimpleDemo
//
//  Copyright © 2020 Tencent. All rights reserved.
//

import TXLiteAVSDK_Professional
import UIKit
import RxSwift
import RxCocoa


/**
 * 观众视角下的RTC视频互动直播房间页面
 *
 * 包含如下简单功能：
 * - 进入/退出直播房间
 * - 显示房间内连麦用户的视频画面（当前示例最多可显示6个连麦用户的视频画面）
 * - 打开/关闭主播以及房间内其他连麦用户的声音和视频画面
 * - 发起/停止连麦
 * - 发起连麦之后，可以切换自己的前置/后置摄像头
 * - 发起连麦之后，可以控制打开/关闭自己的摄像头和麦克风
 */
class TRTCLivePlayViewController: UIViewController {
    
    @IBOutlet var remoteVideoViews: [LiveSubVideoView]!
    @IBOutlet var localVideoView: LiveSubVideoView!
    @IBOutlet var switchCameraButton: UIButton!
    @IBOutlet var roomOwnerVideoView: UIView!
    @IBOutlet var videoMutedTipsView: UIView!
    @IBOutlet var roomIdLabel: UILabel!
    
    var roomId: UInt32 = 0
    var userId: String = ""
    var roomOwner: String = ""
    var disposeBag = DisposeBag()
    @objc var myMid = 0  //我当前的麦序位，用于刷新
    @objc var delegate: TRTCLivePushViewControllerDelegate?

    private lazy var remoteUids = NSMutableOrderedSet.init(capacity: MAX_REMOTE_USER_NUM)
    private var isOwnerVideoStopped: Bool = true
    private var isFrontCamera: Bool = true
    
    private lazy var roomManager = LiveRoomManager.sharedInstance
    private lazy var trtcCloud: TRTCCloud = {
        let instance: TRTCCloud = TRTCCloud.sharedInstance()
        ///设置TRTCCloud的回调接口
        instance.delegate = self;
        return instance;
    }()
    
    @objc var mute:Bool = false{
        
        didSet
        {
            trtcCloud.muteLocalAudio(self.mute)
        }
    };
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.liveContainer)



        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            /// 开启麦克风采集
//            self.trtcCloud.startLocalAudio()
//            /// 开启摄像头采集
//            self.trtcCloud.startLocalPreview(self.isFrontCamera, view: self.liveContainer.getUserContentView(byUserIndex: 0))
//            print(self.liveContainer.getUserContentView(byUserIndex: 0))
            
//            self.liveContainer.viewModel?.output.roomListPush.delay(RxTimeInterval.milliseconds(400), scheduler: MainScheduler.instance).subscribe(onNext:{[weak self] _ in
//                self?.refreshRemoteVideoViews()
//            }).disposed(by: self.disposeBag)
            
           
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @objc lazy var liveContainer:LiveContainerView = {
        
        var type = LiveContainerViewType.LiveContainerViewType4;
        if(GlobalVariables.sharedInstance()?.g_live_type == "4")
        {
            type = LiveContainerViewType.LiveContainerViewType4;
        }
        else if(GlobalVariables.sharedInstance()?.g_live_type == "6")
        {
            type = LiveContainerViewType.LiveContainerViewType6
        }
        else
        {
            type = LiveContainerViewType.LiveContainerViewType9
        }
        
        var view:LiveContainerView = LiveContainerView(frame: CGRect(x: 0, y: 120.auto(), width:UIScreen.main.bounds.width , height: UIScreen.main.bounds.width),by: type);
        return view
    }()

    deinit {
        TRTCCloud.destroySharedIntance()
    }
    
    @objc func onExitLiveClicked() {
        /// 退出视频直播房间
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
//        navigationController?.popViewController(animated: true)
    }

    @objc func onLinkMicClicked(active: Bool,mid:Int) {
        myMid = mid
        
        if !active { /// 停止连麦
            trtcCloud.switch(TRTCRoleType.audience)
            trtcCloud.stopLocalAudio()
            trtcCloud.stopLocalPreview()
//            localVideoView.reset()

        } else { /// 发起连麦

        
            trtcCloud.switch(TRTCRoleType.anchor)
            trtcCloud.startLocalAudio()
            //因为index不同
            trtcCloud.startLocalPreview(isFrontCamera, view: self.liveContainer.getUserContentView(byUserIndex: (mid - 1)))
        }
//        sender.isSelected = !sender.isSelected
    }
    
    func onMuteRoomOwnerVideoClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        /// 打开/关闭当前房主的直播视频画面
        trtcCloud.muteRemoteVideoStream(roomOwner, mute: sender.isSelected)
        roomManager.muteRemoteVideo(forUser: roomOwner, muted: sender.isSelected)
        videoMutedTipsView.isHidden = !(sender.isSelected || isOwnerVideoStopped)
    }
    
    func onMuteRoomOwnerAudioClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        /// 打开/关闭当前房主的声音
        trtcCloud.muteRemoteAudio(roomOwner, mute: sender.isSelected)
        roomManager.muteRemoteAudio(forUser: roomOwner, muted: sender.isSelected)
    }
    
    func onSwitchCameraClicked(_ sender: UIButton) {
        /// 连麦之后，切换自己的前置/后置摄像头
        trtcCloud.switchCamera()
        isFrontCamera = sender.isSelected
        sender.isSelected = !sender.isSelected
    }
    
    func onMuteRemoteVideoClicked(_ sender: UIButton) {
        if localVideoView == sender.superview {
            /// 连麦之后，打开/关闭自己的摄像头
            if sender.isSelected {
                trtcCloud.startLocalPreview(isFrontCamera, view: localVideoView)
            } else {
                trtcCloud.stopLocalPreview()
            }
            localVideoView.muteVideo(!sender.isSelected)
        } else {
            guard let remoteView = sender.superview as? LiveSubVideoView else { return }
            let index = remoteView.tag
            if index < remoteUids.count, let remoteUid = remoteUids[index] as? String {
                /// ??/????uid??????????
                trtcCloud.muteRemoteVideoStream(remoteUid, mute: !sender.isSelected)
                remoteView.muteVideo(!sender.isSelected)
            }
        }
    }
    
    func onMuteRemoteAudioClicked(_ sender: UIButton) {
        if localVideoView == sender.superview {
            /// 连麦之后，打开/关闭自己的麦克风
            if sender.isSelected {
                trtcCloud.startLocalAudio()
            } else {
                trtcCloud.stopLocalAudio()
            }
            localVideoView.muteAudio(!sender.isSelected)
        } else {
            guard let remoteView = sender.superview as? LiveSubVideoView else { return }
            let index = remoteView.tag
            if index < remoteUids.count, let remoteUid = remoteUids[index] as? String {
                /// ??/????uid????????
                trtcCloud.muteRemoteAudio(remoteUid, mute: !sender.isSelected)
                remoteView.muteAudio(!sender.isSelected)
            }
        }
    }
    
    @IBAction func onDashboardClicked(_ sender: UIButton) {
        /// 显示调试信息
        sender.tag += 1
        if sender.tag > 2 {
            sender.tag = 0
        }
        trtcCloud.showDebugView(sender.tag)
        sender.isSelected = sender.tag > 0
    }
}

extension TRTCLivePlayViewController: TRTCCloudDelegate {


    public func onEnterRoom(_ result: Int) {
        print("进入房间回调 \(result)  userSign : \(String(describing: IMALoginParam.loadFromLocal()?.userSig))")
        self.delegate?.onEnterRoom(result)
    }

    /**
     * 当前视频通话房间里的其他用户开启/关闭摄像头时会收到这个回调
     * 此时可以根据这个用户的视频available状态来 “显示或者关闭” Ta的视频画面
     */
//    func onUserVideoAvailable(_ userId: String, available: Bool) {
//        guard userId != roomOwner else {
//            refreshRoomOwnerVideoView(available: available)
//            return
//        }
//
//        //这修改插入时的麦序
//        let index = remoteUids.index(of: userId)
//        if available {
//            guard NSNotFound == index else { return }
//            remoteUids.add(userId)
//            refreshRemoteVideoViews(from: index)
//        } else {
//            guard NSNotFound != index else { return }
//            /// 关闭用户userId的视频画面
//            trtcCloud.stopRemoteView(userId)
//            remoteUids.removeObject(at: index)
//            refreshRemoteVideoViews(from: index)
//        }
//    }
    
    func refreshRemoteVideoViews() {
        
        //刷新tb
//        self.trtcCloud.stopLocalPreview()
//        self.trtcCloud.startLocalPreview(self.isFrontCamera, view: self.liveContainer.getUserContentView(byUserIndex: 0))
        //主播肯定不是空的
        for (i,item) in (self.liveContainer.viewModel?.output.listData.enumerated())! {
            
            if(i == 0)
            {
                //刷新主播视图
                self.trtcCloud.stopRemoteView(item.userId)
                self.trtcCloud.startRemoteView(self.roomOwner, view: self.liveContainer.getUserContentView(byUserIndex: 0))
//                i = i+1
                continue
            }
            
            if(i == (myMid - 1))
            {
                //刷新我当前的麦位，原因是这次collection复用会导致显示异常
       
                    trtcCloud.stopLocalPreview()
                    //因为index不同
                    trtcCloud.startLocalPreview(isFrontCamera, view: self.liveContainer.getUserContentView(byUserIndex: (myMid - 1)))
//                i = i+1
                continue
            }
            
//            i = i+1

            
            if(item.userId == nil){continue}
            self.trtcCloud.stopRemoteView(item.userId)
            
            self.trtcCloud.startRemoteView(item.userId!, view: self.liveContainer.getUserContentView(byUserIndex: (Int(item.number)! - 1)))
            
        }
    }
    
    func refreshRemoteVideoViews(from: Int) {
//        trtcCloud.startRemoteView(remoteUid, view: self.liveContainer.getUserContentView(byUserIndex: from))
    }
    
    /// 打开/关闭房主的视频画面
    func refreshRoomOwnerVideoView(available: Bool) {
        if available {
            trtcCloud.startRemoteView(roomOwner, view: self.liveContainer.getUserContentView(byUserIndex: 0))

        } else {
            trtcCloud.stopRemoteView(roomOwner)
        }
        isOwnerVideoStopped = !available
//        videoMutedTipsView.isHidden = !(roomManager.isVideoMuted(forUser: roomOwner) || isOwnerVideoStopped)
    }
    
    /// 有用户进入当前视频直播房间
    func onRemoteUserEnterRoom(_ userId: String) {
        roomManager.onRemoteUserEnterRoom(userId: userId)
    }
    
    /// 有用户离开当前视频直播房间
    func onRemoteUserLeaveRoom(_ userId: String, reason: Int) {
    
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LiveContainerViewNeedReload"), object: nil)

//        self.liveContainer.needRefresh()
        
        roomManager.onRemoteUserLeaveRoom(userId: userId)
    }

    @objc func muteAudio(mute:Bool)
    {
        trtcCloud.muteLocalAudio(mute)
    }
    
    @objc func openAudio(open:Bool)
    {
        if(open)
        {
            trtcCloud.switch(TRTCRoleType.anchor);
            trtcCloud.startLocalAudio(TRTCAudioQuality.default)

        }
        else
        {
            trtcCloud.switch(TRTCRoleType.audience);
            trtcCloud.stopLocalAudio()
        }
    }
    
    /*roomOwner为主播id */
    @objc func startLive(roomId:String,emccID:String,userId:String)
    {
//        roomIdLabel.text = "\(roomId)"

        /// 房主的uid就是房间id
         roomOwner = emccID
//        roomIdLabel.text = roomOwner

        /**
         * 设置参数，进入视频直播房间
         * 房间号param.roomId，当前用户id param.userId
         * param.role 指定以TRTCRoleType.audience（观众角色）进入房间
         */
        let param = TRTCParams.init()
        param.sdkAppId = UInt32(SDKAppID)
        param.roomId   = UInt32(roomId) ?? 0
        param.userId   = userId
        param.role     = TRTCRoleType.audience
        /// userSig是进入房间的用户签名，相当于密码（这里生成的是测试签名，正确做法需要业务服务器来生成，然后下发给客户端）
        param.userSig  = BGIMLoginManager.sharedInstance().loginParam.userSig
        /// 指定以“在线直播场景”（TRTCAppScene.LIVE）进入房间
        trtcCloud.enterRoom(param, appScene: TRTCAppScene.voiceChatRoom)

        /// 设置直播房间的画质（帧率 15fps，码率400, 分辨率 270*480）
//        let videoEncParam = TRTCVideoEncParam.init()
//        videoEncParam.videoResolution = TRTCVideoResolution._480_270
//        videoEncParam.videoBitrate = 400
//        videoEncParam.videoFps = 15
//        trtcCloud.setVideoEncoderParam(videoEncParam)

        /**
         * 设置默认美颜效果（美颜效果：光滑，美颜级别：5, 美白级别：1）
         * 互动直播场景推荐使用“光滑”美颜效果
         */
//        let beautyManager = trtcCloud.getBeautyManager()
//        beautyManager?.setBeautyStyle(TXBeautyStyle.smooth)
//        beautyManager?.setBeautyLevel(5)
//        beautyManager?.setWhitenessLevel(1)

        /// 调整仪表盘显示位置
        trtcCloud.setDebugViewMargin(roomOwner, margin: TXEdgeInsets.init(top: 80, left: 0, bottom: 0, right: 0))
    }

}
