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
    // MARK: - 화면 관련
    var handShakeView: HandShakeView!
    /// 메인화면
    var mainView: MainView!
    
    @StateObject var viewModel: LoginVM
    
    /// QR코드화면 이동 값
    @State var navToQRCode: Bool = false {
        didSet {
            print("LoginView - navToQRCode = \(navToQRCode)")
        }
    }
    
    /// 메인화면 이동 값
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
        NavigationView {
            contentView
        }
        // QR코드화면으로 이동
        .sheet(isPresented: self.$navToQRCode, content: {
            HandShakeView(code: self.viewModel.code)
        })
        // 메인화면으로 이동
        .sheet(isPresented: self.$navToMain, content: {
            MainView(viewModel: self.viewModel)
        })
        .onAppear() {
            // 재연결
            self.viewModel.walletConnect.reconnectIfNeeded()
        }
        // QR코드 화면 이동 이벤트 받음
        .onReceive(self.viewModel.navToQRCodeView) { flag in
            print("navToQRCodeView - flag = \(flag)")
            self.navToQRCode = flag
        }
        // 메인화면 이동 이벤트 받음
        .onReceive(self.viewModel.navToMainView) { flag in
            print("navToMainView - flag = \(flag)")
            self.navToMain = flag
        }
    }
    
    /// 컨텐츠 뷰
    var contentView: some View {
        VStack(spacing: 10) {
            Spacer()
            
            Button {
                // 연결
                self.viewModel.connect()
            } label: {
                Text("연결하기")
                    .foregroundColor(.white)
                    .padding(10)
            }
            .background(.blue)
            
            Spacer()
        }
    }
}
