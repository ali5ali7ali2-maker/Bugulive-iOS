//
//  LivePushViewController.swift
//  TRTCSimpleDemo
//
//  Copyright © 2020 Tencent. All rights reserved.
//

import TXLiteAVSDK_Professional
import UIKit
import Then
import RxSwift
import TCBeautyPanel
struct LiveVideoConfig {
    var bitrate: Int32 = 850
    var resolutionName = "高"
    var resolutionDesc = "高清：540*960"
    var resolution = TRTCVideoResolution._960_540
}

/**
 * 主播视角下的RTC视频互动直播房间页面
 *
 * 包含如下简单功能：
 * - 进入/退出直播房间
 * - 切换前置/后置摄像头
 * - 打开/关闭摄像头
 * - 打开/关闭麦克风
 * - 切换视频直播的画质（标清、高清、超清）
 * - 显示房间内连麦用户的视频画面（当前示例最多可显示6个连麦用户的视频画面）
 * - 打开/关闭连麦用户的声音和视频画面
 */
@objc(TRTCLivePushViewControllerDelegate)
protocol TRTCLivePushViewControllerDelegate {
    func onEnterRoom(_ result: Int)
}

class TRTCLivePushViewController: UIViewController {
    @objc var delegate: TRTCLivePushViewControllerDelegate?
    var remoteVideoViews: [LiveSubVideoView]!
    var videoMutedTipsView: UIImageView!
    var localVideoView: UIView!
    var roomIdLabel: UILabel!
    
    var roomId: UInt32 = 0
    var userId: String = ""
    var tiSdkBridging: TRTCBridging!
    @objc var beautyPannel = TCBeautyPanel()
//    @objc var mute = false;//是否静音
    @objc var mute:Bool = false{
        
        didSet
        {
            trtcCloud.muteLocalAudio(self.mute)
        }
    };
    
    //闪光灯
    @objc var torch = false{
        didSet
        {
            trtcCloud.enbaleTorch(self.torch)
        }
    }
    
    //镜像
    @objc var mirror = false
    {
        //
//        TRTCLocalVideoMirrorType_Enable     = 1,       ///< 前后置摄像头画面均镜像
//        TRTCLocalVideoMirrorType_Disable    = 2,
        //setLocalViewMirror
        didSet
        {
            if(self.mirror)
            {
                trtcCloud.setLocalViewMirror(.enable)
            }
            else
            {
                trtcCloud.setLocalViewMirror(.disable)
            }
        }
    }
    
    
    
    var disposeBag = DisposeBag()
    
    /// 直播画质配置参数（标清、高清、超清画质下的码率和分辨率）
    private lazy var videoConfigs: [LiveVideoConfig] = {
        return [
            LiveVideoConfig(bitrate: 900, resolutionName: "标", resolutionDesc: "标清：360*640", resolution: TRTCVideoResolution._640_360),
            LiveVideoConfig(bitrate: 1200, resolutionName: "高", resolutionDesc: "高清：540*960", resolution: TRTCVideoResolution._960_540),
            LiveVideoConfig(bitrate: 1500, resolutionName: "超", resolutionDesc: "超清：720*1280", resolution: TRTCVideoResolution._1280_720)
        ]
    }()
    private lazy var remoteUids = NSMutableOrderedSet.init(capacity: MAX_REMOTE_USER_NUM)
    private let videoEncParam = TRTCVideoEncParam.init()
    private var isFrontCamera: Bool = true

    private lazy var roomManager = LiveRoomManager.sharedInstance
    private lazy var trtcCloud: TRTCCloud = {
        let instance: TRTCCloud = TRTCCloud.sharedInstance()
        ///设置TRTCCloud的回调接口
        instance.delegate = self;
        return instance;
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAll()
    }

    func configureAll() {


        tiSdkBridging = TRTCBridging.init();
//        self.view.addSubview(self.liveContainer)
        self.mute = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            /// 开启麦克风采集
            self.trtcCloud.startLocalAudio()
            /// 开启摄像头采集
            self.trtcCloud.startLocalPreview(self.isFrontCamera, view: self.liveContainer.getUserContentView(byUserIndex: 0))
//            print(self.liveContainer.getUserContentView(byUserIndex: 0))
            
            self.liveContainer.viewModel?.output.roomListPush.delay(.milliseconds(400), scheduler: MainScheduler.instance).subscribe(onNext:{[weak self] _ in
                self?.refreshRemoteVideoViews()
            }).disposed(by: self.disposeBag)
            
        }
        
        // 美颜设置
        let bottomOffset: CGFloat = 55
        let height = CGFloat(TCBeautyPanel.getHeight())
        let theme = TCBeautyPanelTheme()
        
        let cyanColor = UIColor(red: 11.0/255, green: 204.0/255, blue: 172.0/255, alpha: 1.0)
        theme.beautyPanelSelectionColor = cyanColor;
//        theme.beautyPanelMenuSelectionBackgroundImage = UIImage(named: "beauty_selection_bg")!
//        theme.sliderThumbImage = UIImage(named: "slider")!
        theme.sliderValueColor = theme.beautyPanelSelectionColor;
        theme.sliderMinColor = cyanColor;
        
        let frame = CGRect(x: 0, y: view.frame.height - height - bottomOffset, width: view.frame.width, height: height)
        beautyPannel = TCBeautyPanel(frame: frame, theme: theme, actionPerformer: TCBeautyPanelActionProxy.init(sdkObject: TRTCCloud.sharedInstance()))
        beautyPannel.bottomOffset = 0
        beautyPannel.isHidden = true
//        view.addSubview(beautyPannel)
        
        
        

    }
    

    
    @objc func switchCamera()
    {
        self.trtcCloud.switchCamera()
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

    func configureLayout() {

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        

    }

    @objc func startLive(roomId:String,userId:String)
    {
        
        MikeStatus.sharedInstance.resetData()
//        roomIdLabel.text = "\(roomId)"

        /**
         * 设置参数，进入视频直播房间
         * 房间号param.roomId，当前用户id param.userId
         * param.role 指定以TRTCRoleType.anchor（主播角色）进入房间
         */
        let param = TRTCParams.init()
        param.sdkAppId = UInt32(SDKAppID)
        param.roomId   = UInt32(roomId) ?? 0
        param.userId   = userId
        param.role     = TRTCRoleType.anchor
        /// userSig是进入房间的用户签名，相当于密码（这里生成的是测试签名，正确做法需要业务服务器来生成，然后下发给客户端）
        param.userSig  = IMALoginParam.loadFromLocal()?.userSig ?? ""

        /// 指定以“在线直播场景”（TRTCAppScene.LIVE）进入房间
        trtcCloud.enterRoom(param, appScene: TRTCAppScene.LIVE)
        roomManager.createLiveRoom(roomId: "\(roomId)")

        /// 默认设置高清的直播画质（帧率 15fps, 码率 1200, 分辨率 540*960）
        videoEncParam.videoResolution = TRTCVideoResolution._960_540
        videoEncParam.videoBitrate = 1200
        videoEncParam.videoFps = 15
        trtcCloud.setVideoEncoderParam(videoEncParam)

        /**
         * 设置默认美颜效果（美颜效果：光滑，美颜级别：5, 美白级别：1）
         * 互动直播场景推荐使用“光滑”美颜效果
         */
        let beautyManager = trtcCloud.getBeautyManager()
        beautyManager?.setBeautyStyle(TXBeautyStyle.smooth)
        beautyManager?.setBeautyLevel(5)
        beautyManager?.setWhitenessLevel(1)

        /// 调整仪表盘显示位置
        trtcCloud.setDebugViewMargin(userId, margin: TXEdgeInsets.init(top: 80, left: 0, bottom: 0, right: 0))
        
        tiSdkBridging.tiInit()
    }



    deinit {
        TRTCCloud.destroySharedIntance()
    }
    
    @objc func onExitLiveClicked() {
        /// 退出房间，结束视频直播
        trtcCloud.exitRoom()
        roomManager.destroyLiveRoom(roomId: "\(roomId)")
        trtcCloud.stopLocalPreview()
        tiSdkBridging.deInit();
        navigationController?.popViewController(animated: true)
    }
    
    func onVideoCaptureClicked(_ sender: UIButton) {
        if sender.isSelected { /// 开启摄像头采集
            trtcCloud.startLocalPreview(isFrontCamera, view: localVideoView)
        } else { /// 关闭摄像头采集
            trtcCloud.stopLocalPreview()
        }
        videoMutedTipsView.isHidden = sender.isSelected
        sender.isSelected = !sender.isSelected
    }
    
    func onMicCaptureClicked(_ sender: UIButton) {
        if sender.isSelected { /// 开启麦克风采集
            trtcCloud.startLocalAudio()
        } else { /// 关闭麦克风采集
            trtcCloud.stopLocalAudio()
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onSwitchCameraClicked(_ sender: UIButton) {
        /// 切换前置/后置摄像头
        trtcCloud.switchCamera()
        isFrontCamera = sender.isSelected
        sender.isSelected = !sender.isSelected
    }
    
    func onMuteRemoteVideoClicked(_ sender: UIButton) {
            guard let remoteView = sender.superview as? LiveSubVideoView else { return }
            let index = remoteView.tag
            if index < remoteUids.count, let remoteUid = remoteUids[index] as? String {
                /// ??/????uid??????????
                trtcCloud.muteRemoteVideoStream(remoteUid, mute: !sender.isSelected)
                remoteView.muteVideo(!sender.isSelected)
            }
    }
    
    func onMuteRemoteAudioClicked(_ sender: UIButton) {
            guard let remoteView = sender.superview as? LiveSubVideoView else { return }
            let index = remoteView.tag
            if index < remoteUids.count, let remoteUid = remoteUids[index] as? String {
                /// ??/????uid????????
                trtcCloud.muteRemoteAudio(remoteUid, mute: !sender.isSelected)
                remoteView.muteAudio(!sender.isSelected)
            }
    }
    
    func onResolutionClicked(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "分辨率", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        for config in videoConfigs {
            alert.addAction(UIAlertAction.init(title: config.resolutionDesc, style: UIAlertAction.Style.default, handler: { [weak self] (action) in
                guard let self = self else { return }
                sender.setTitle(config.resolutionName, for: UIControl.State.normal)
                /// 切换视频直播的画质（标清、高清、超清）
                self.videoEncParam.videoResolution = config.resolution
                self.videoEncParam.videoBitrate = config.bitrate
                self.trtcCloud.setVideoEncoderParam(self.videoEncParam)
            }))
        }
        alert.addAction(UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

extension TRTCLivePushViewController: TRTCCloudDelegate {
    public func onEnterRoom(_ result: Int) {
        print("进入房间回调 \(result)  usersign : \(String(describing: IMALoginParam.loadFromLocal()?.userSig))")
        self.delegate?.onEnterRoom(result)
    }

    /**
     * 当前视频直播房间里的其他用户开启/关闭摄像头时会收到这个回调
     * 此时可以根据这个用户的视频available状态来 “显示或者关闭” Ta的视频画面
     */
//    func onUserVideoAvailable(_ userId: String, available: Bool) {
//        let index = remoteUids.index(of: userId)
//        if available {
//            guard NSNotFound == index else { return }
//            remoteUids.add(userId)
//            refreshRemoteVideoViews(from: remoteUids.count - 1)
//        } else {
//            guard NSNotFound != index else { return }
//            /// 关闭用户userId的视频画面
//            trtcCloud.stopRemoteView(userId)
//            remoteUids.removeObject(at: index)
////            refreshRemoteVideoViews(from: index)
//        }
//    }
    
//    func refreshRemoteVideoViews(from: Int) {
//
//        //刷新tb
//
//
//        for item in (self.liveContainer.viewModel?.output.listData)! {
//            if(item.userId == nil){return}
//            self.trtcCloud.stopRemoteView(item.userId)
//
//            self.trtcCloud.startRemoteView(item.userId!, view: self.liveContainer.getUserContentView(byUserIndex: (Int(item.number)! - 1)))
//
//        }
//    }
//
    
    func refreshRemoteVideoViews() {
        
        //刷新tb
        self.trtcCloud.stopLocalPreview()
        self.trtcCloud.startLocalPreview(self.isFrontCamera, view: self.liveContainer.getUserContentView(byUserIndex: 0))
        
        
        for item in (self.liveContainer.viewModel?.output.listData)! {
            if(item.userId == nil){continue}
            self.trtcCloud.stopRemoteView(item.userId)
            
            self.trtcCloud.startRemoteView(item.userId!, view: self.liveContainer.getUserContentView(byUserIndex: (Int(item.number)! - 1)))
            
        }
    }
    
    /// 有用户进入当前视频直播房间
    func onRemoteUserEnterRoom(_ userId: String) {
        roomManager.onRemoteUserEnterRoom(userId: userId)
    }
    
    /// 有用户离开当前视频直播房间
    func onRemoteUserLeaveRoom(_ userId: String, reason: Int) {
        roomManager.onRemoteUserLeaveRoom(userId: userId)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LiveContainerViewNeedReload"), object: nil)

    }
    
    
}
