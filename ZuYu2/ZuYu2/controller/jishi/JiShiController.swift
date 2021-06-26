//
//  JiShiController.swift
//  ZuYu2
//
//  Created by million on 2020/8/3.
//  Copyright © 2020 million. All rights reserved.
//

import UIKit
import RxSwift

class JiShiController: UIViewController {
    
    @IBOutlet weak var shadowView1: UIView!
    
    @IBOutlet weak var shadowView2: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var roomInfoView: UIStackView!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var projectLB: UILabel!
    @IBOutlet weak var roomNum: UILabel!
    @IBOutlet weak var tipStartTime: UILabel!
    @IBOutlet weak var topLine: DashLine!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var bottomLine: DashLine!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var jsStatusLB: UILabel!
    let disposeBag = DisposeBag()
    
    var techStatusModel:TechStatusModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        initData()
        setupYKWoodpecker()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reLoadInitData), name: NSNotification.Name("JSNotification"), object: nil)
    }
    
    @objc func reLoadInitData(){
        initData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initData(){
        
        NetManager.request(.getTechStatus, entity: [TechStatusModel].self)
            .subscribe(onNext: { [weak self] (result) in
          guard let self = self else { return }
          print(result)
            self.techStatusModel = result.first
                guard let model = self.techStatusModel else {return}
                //设置推送别名
                JPUSHService.setAlias("JS\(model.techId ?? 0)", completion: { (iResCode,iAlias,seq) in
                    print("iResCode---\(iResCode)")
                    print("iAlias---\(iAlias ?? "")")
                    print("seq---\(seq)")
                }, seq: 0)
                
                //如果techStatus == 1 或 0 表示 空闲状态
                if model.techStatus ?? 0 == 1 || model.techStatus ?? 0  == 0{
                    self.roomInfoView.isHidden = true
                    self.topLine.isHidden = true
                    self.bottomLine.isHidden = true
                    self.tipStartTime.isHidden = true
                    self.startTime.isHidden = true
                    self.timeLB.text = "空闲中"
                    self.jsStatusLB.isHidden = true
                }else{
                    self.roomInfoView.isHidden = false
                    self.topLine.isHidden = false
                    self.bottomLine.isHidden = false
                    self.tipStartTime.isHidden = false
                    self.startTime.isHidden = false
                    self.jsStatusLB.isHidden = false
                    self.timeLB.text = "00:00:00"
                    self.roomName.text = self.techStatusModel?.roomName ?? ""
                    self.projectLB.text = self.techStatusModel?.projectName ?? ""
                    self.roomNum.text = self.techStatusModel?.appointUser ?? ""
                    self.startTime.text = dealTimeStr(timeStr: self.techStatusModel?.createTime ?? "")
                    
                }
                
          }).disposed(by: disposeBag)
    }
    
    func setUpUI() {
        initNavigationItem()
        scrollView.backgroundColor = UIColor.init(hexString: "FCFCFC")
        scrollView.contentInsetAdjustmentBehavior = .never
        shadowView1.addShadow(ofColor: UIColor(red: 0.28, green: 0, blue: 0.05, alpha: 0.06), radius: 16, offset: CGSize.init(width: 0, height: 4), opacity: 1)
        shadowView2.addShadow(ofColor: UIColor(red: 0.28, green: 0, blue: 0.05, alpha: 0.06), radius: 16, offset: CGSize.init(width: 0, height: 4), opacity: 1)
    }
    
    func initNavigationItem()  {
        //全透明
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let user = getUser() {
            navigationItem.title = "技师:\(user.name ?? "")(\(user.empCode ?? "")"
            
        }
        let xiaoxi = UIBarButtonItem.init(image: UIImage.init(named: "xiaoxi")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(JiShiController.xiaoxi(_:)))
        let qiehuan = UIBarButtonItem.init(image: UIImage.init(named: "qiehuan")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(JiShiController.qiehuan(_:)))
        navigationItem.rightBarButtonItems = [qiehuan, xiaoxi]
        
        AboutAuth.photoAndCameraAuthAction(view: self.view)
        
    }
    
    func showActionSheet() {
        let vc = RoleController.init(nibName: RoleController.className, bundle: nil)
        vc.type = .jishi
        vc.onItemTapped = {
            index in
            if index == 0 {
                clientType = .gudong
            }
            if index == 1 {
                clientType = .loumian
            }
            if index == 2 {
                clientType = .jishi
            }
            if index == 3 {
                clientType = .qiehuan
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: {
            vc.backgroundView.backgroundColor = .black
            vc.backgroundView.alpha = 0.1
        })
    }
    
    /// 切换角色
    @objc func qiehuan(_ sender : Any) {
        showActionSheet()
    }
    
    @objc func xiaoxi(_ sender : Any) {
        
    }
    
    /// 呼叫商品
    @IBAction func callcommodity(_ sender: Any) {
//        let vc = WebController.init("\(h5BaseUrl)/#/callcommodity")
        let vc = WebController.init("\(serverJSJsUrl)/#/callcommodity")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
    
    @IBAction func checkoutroom(_ sender: Any) {
        let vc = WebController.init("\(serverJSJsUrl)/#/checkoutroom", roomId: techStatusModel?.roomId)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
    
    @IBAction func replaceproject(_ sender: Any) {
        let vc = WebController.init("\(serverJSJsUrl)/#/replaceproject")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
    
    @IBAction func serviceclock(_ sender: Any) {
        let vc = WebController.init("\(serverJSJsUrl)/#/serviceclock")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
    
    /// TODO:考勤打卡
    
    @IBAction func appointment(_ sender: Any) {
        let vc = WebController.init("\(serverJSJsUrl)/#/appointment")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
    
    
    @IBAction func management(_ sender: Any) {
        let vc = WebController.init("\(serverJSJsUrl)/#/management")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
    
    @IBAction func clockfake(_ sender: Any) {
        let vc = WebController.init("\(serverJSJsUrl)/#/clockfake")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
    
    @IBAction func rechargevip(_ sender: Any) {
        let vc = WebController.init("\(serverJSJsUrl)/#/rechargevip")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
    
    @IBAction func servicemanagement(_ sender: Any) {
        let vc = WebController.init("\(serverJSJsUrl)/#/servicemanagement")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
    
    @IBAction func openorder(_ sender: Any) {
        
        guard let mode = self.techStatusModel else { return }
        if mode.techStatus ?? 0 == 1 || mode.techStatus ?? 0 == 0 {
            view.makeToast("空闲中，不能自由开单")
            return
        }
        let vc = WebController.init("\(serverJSJsUrl)/#/openorder")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
