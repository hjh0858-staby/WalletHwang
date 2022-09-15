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
    
    /// 화면 전환
    @Published var isPresent: Bool = false {
        didSet {
            print("LoginVM - isPresent = \(isPresent)")
        }
    }
    
    var navToMainView = PassthroughSubject<Bool, Never>()
    
    // MARK: - init
    init() {
        self.walletConnect = WalletConnect(delegate: self)
    }
    
    /// 연결
    func connect() {
        let connectionUrl = walletConnect.connect()
        print("connectionUrl = \(connectionUrl)")
        
        let deepLinkUrl = "wc://wc?uri=\(connectionUrl)"
        print("deepLinkUrl = \(deepLinkUrl)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.code = connectionUrl
            if let url = URL(string: deepLinkUrl), UIApplication.shared.canOpenURL(url) {
                print("url = \(url)")
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("url 없음")
                self.isPresent = true
            }
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
        self.navToMainView.send(true)
    }
    
    /// 연결이 끊겼을 때
    func didDisconnect() {
        print("didDisconnect")
        self.navToMainView.send(false)
    }
}
