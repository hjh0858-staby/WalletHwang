//
//  ContentView.swift
//  WalletHwang
//
//  Created by 황재현 on 2022/08/31.
//

import SwiftUI
import WalletConnectSwift


/// 로그인 뷰
struct LoginView: View {
    /// 메타마스크 연결
    @StateObject var walletConnect: WalletConnect
    
    var delegate: WalletConnectDelegate
    
    // MARK: - 화면 관련
    var handShakeView: HandShakeView!
    /// 메인화면
    var mainView: MainView!
    
    /// 화면 전환
    @State var isPresent: Bool = false
    /// 코드
    @State var code: String = "" {
        didSet {
            print("didSet - code = \(code)")
        }
    }
    
    // MARK: - init
    init() {
        self._walletConnect = StateObject.init(wrappedValue: WalletConnect(delegate: <#T##WalletConnectDelegate#>))
    }
    
    
    // MARK: - body
    var body: some View {
        contentView
            .sheet(isPresented: $isPresent) {
                HandShakeView(code: code)
            }
            .onAppear() {
                // 재연결
                self.walletConnect.reconnectIfNeeded()
            }
    }
    
    /// 컨텐츠 뷰
    var contentView: some View {
        NavigationView {
            VStack(spacing: 10) {
                Spacer()
                
                Button {
                    // 연결
                    self.connect()
                } label: {
                    Text("눌러보세욥")
                        .foregroundColor(.white)
                        .padding(10)
                }
                .background(.blue)
                
                Spacer()
            }.background(.green.opacity(0.4))
        }
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
    
    func onMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
}

extension LoginView: WalletConnectDelegate {
    func failedToConnect() {
        print("failedToConnect")
    }
    
    func didConnect() {
        print("didConnect")
    }
    
    func didDisconnect() {
        print("didDisconnect")
    }
}
