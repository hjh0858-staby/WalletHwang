//
//  MainView.swift
//  WalletHwang
//
//  Created by 황재현 on 2022/09/05.
//

import SwiftUI
import WalletConnectSwift

/// 메인 화면
struct MainView: View {
    /// 뷰모델
    @StateObject var viewModel: LoginVM
    
    // MARK: - init
    init(viewModel: LoginVM) {
        print("MainView - init()")
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    // MARK: - body
    var body: some View {
        contentView
    }
    
    /// 컨텐츠 뷰
    var contentView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text(viewModel.walletConnect.session.walletInfo?.accounts[0] ?? "nil-nil")
            
            Button {
                // 해제
                self.viewModel.disconnect()
            } label: {
                Text("연결해제")
            }
            
            Spacer()
        }
    }
}
