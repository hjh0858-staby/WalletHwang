//
//  ContentView.swift
//  WalletHwang
//
//  Created by 황재현 on 2022/08/31.
//

import SwiftUI

struct ContentView: View {
    
    var handShakeView: HandShakeView!
    var walletConnect: WalletConnect!
    
    var body: some View {
        contentView
    }
    
    
    var contentView: some View {
        NavigationView {
            VStack(spacing: 10) {
                Spacer()
                
                Button {
                    // 연결
                    self.connect()
                } label: {
                    Text("눌러보세요오오오오옹아아")
                        .foregroundColor(.white)
                        .padding(10)
                }
                .background(.blue)

                
                Spacer()
            }.background(.green.opacity(0.4))
        }
    }
    
    func connect() {
        let connectionUrl = walletConnect.connect()
        print("connectionUrl = \(connectionUrl)")
        
        let deepLinkUrl = "wc://wc?uri=\(connectionUrl)"
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let url = URL(string: deepLinkUrl), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {

            }
        }
    }
}
