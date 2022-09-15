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
//    var walletConnect: WalletConnect
    
    // MARK: - 화면 관련
    var handShakeView: HandShakeView!
    /// 메인화면
    var mainView: MainView!
    
    @StateObject var viewModel: LoginVM
    
    @State var isPresent: Bool = false {
        didSet {
            print("LoginView - isPresent = \(isPresent)")
        }
    }
    
    @State var navToMain: Bool = false {
        didSet {
            print("LoginView - navToMain = \(navToMain)")
        }
    }
    
    // MARK: - init
    init() {
        self._viewModel = StateObject(wrappedValue: LoginVM())
    }
    
    
    // MARK: - body
    var body: some View {
        contentView
            .sheet(isPresented: self.$isPresent) {
                HandShakeView(code: self.viewModel.code)
            }
            .sheet(isPresented: self.$navToMain, content: {
                MainView()
            })
            .onAppear() {
                // 재연결
                self.viewModel.walletConnect.reconnectIfNeeded()
            }
            // QR코드 화면 이동 이벤트 받음
            .onReceive(self.viewModel.$isPresent) { flag in
                self.isPresent = flag
            }
            // 메인화면 이동 이벤트 받음
            .onReceive(self.viewModel.navToMainView) { flag in
                print("onReceive - flag = \(flag)")
                self.navToMain = flag
            }
    }
    
    /// 컨텐츠 뷰
    var contentView: some View {
        NavigationView {
            VStack(spacing: 10) {
                Spacer()
                
                Button {
                    // 연결
                    self.viewModel.connect()
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
