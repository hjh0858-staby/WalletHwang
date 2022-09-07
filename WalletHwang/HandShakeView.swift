//
//  HandShakeView.swift
//  WalletHwang
//
//  Created by 황재현 on 2022/08/31.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

/// QR코드 로그인 뷰
struct HandShakeView: View {
    
    /// 화면 전환 여부 바인딩 값
//    @Binding var isPresented: Bool
    
    /// 코드
    var code: String!
    
    
    // MARK: - init
    init(code: String) {
        print("code = \(code)")
        self.code = code
    }
    
    // MARK: - body
    var body: some View {
        contentView
    }
    
    /// 컨텐츠 뷰
    var contentView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("code = \(code)")
            
            Spacer()
        }
    }
}
