//
//  LoginVM.swift
//  WalletHwang
//
//  Created by 황재현 on 2022/09/15.
//

import Foundation
import UIKit
import Combine
import WalletConnectSwift


/// 뷰모델
class LoginVM: ObservableObject {
    var walletConnect: WalletConnect!
    
    /// 코드
    @Published var code: String = "" {
        didSet {
            print("didSet - code = \(code)")
        }
    }
    
    /// 연결 성공 메인화면으로 이동
    var navToMainView = PassthroughSubject<Bool, Never>()
    
    /// QR코드 화면으로 이동
    var navToQRCodeView = PassthroughSubject<Bool, Never>()
    
    // MARK: - init
    init() {
        self.walletConnect = WalletConnect(delegate: self)
    }
    
    /// 연결
    func connect() {
        print("LoginVM - connect()")
        let connectionUrl = walletConnect.connect()
        print("connectionUrl = \(connectionUrl)")
        
        let deepLinkUrl = "wc://wc?uri=\(connectionUrl)"
        print("deepLinkUrl = \(deepLinkUrl)")
        
        UserDefaults.standard.setValue(connectionUrl, forKey: "userInfo")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.code = connectionUrl
            if let url = URL(string: deepLinkUrl), UIApplication.shared.canOpenURL(url) {
                print("Test - url = \(url) / 메타마스크 이동")
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Test - url 없음 / QR코드화면 이동")
                self.navToQRCodeView.send(true)
                self.navToMainView.send(false)
            }
        }
    }
    
    /// 연결 해제
    func disconnect() {
        print("LoginVM - disconnect()")
        walletConnect.disConnect()
    }
    
    /// 메인 쓰레드에서
    func onMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    func checkUserInfo() -> String? {
        print("LoginVM - checkUserUnfo()")
        if let userData = UserDefaults.standard.string(forKey: "userInfo") {
            print("LoginVM - checkUserUnfo() - userData = \(userData)")
            return userData
        } else {
            print("LoginVM - checkUserUnfo() - userData 없음")
            return nil
        }
    }
}

extension LoginVM: WalletConnectDelegate {
    /// 연결에 실패했을 때
    func failedToConnect() {
        print("failedToConnect")
    }
    
    /// 연결됬을 때
    func didConnect() {
        print("didConnect")
        onMainThread { [unowned self] in
            // 로그인 한 값이 있으면
            if checkUserInfo() != nil {
                print("LoginVM - didConnect() - checkUserInfo = \(checkUserInfo())")
                self.navToQRCodeView.send(false)
                self.navToMainView.send(true)
            } else {
                print("LoginVM - didConnect() - checkUserInfo - nil")
                self.navToMainView.send(false)
            }
        }
    }
    
    /// 연결이 끊겼을 때
    func didDisconnect() {
        print("didDisconnect")
        self.navToMainView.send(false)
    }
}
