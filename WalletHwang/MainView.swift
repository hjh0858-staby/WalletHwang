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
        VStack(spacing: 10) {
            Spacer()
            
            infoView
            
            disconnectBtn
            
            sendBtn
            
            Spacer()
        }
    }
    
    
    /// 정보 뷰
    var infoView: some View {
        VStack(spacing: 0) {
            Text("주소: ")
            Text(viewModel.walletConnect.session.walletInfo?.accounts[0] ?? "nil-nil")
            
            Spacer().frame(height: 10)
            
            Text("정보: perrId")
            Text(viewModel.walletConnect.session.walletInfo?.peerId ?? "nil_nil")
            
            Text("정보: chainId")
            Text("\(viewModel.walletConnect.session.walletInfo?.chainId ?? 0)")
            
//            Text(viewModel.walletConnect.session.walletInfo?.peerMeta.name ?? "nil_nil")
//            Text(viewModel.walletConnect.session.walletInfo?.peerMeta.description ?? "nil_nil")
//            Text(viewModel.walletConnect.session.walletInfo?.peerMeta.scheme ?? "nil_nil")
        }
    }
    
    
    /// 연결해제 버튼
    var disconnectBtn: some View {
        VStack {
            Button {
                // 해제
                self.viewModel.disconnect()
            } label: {
                Text("연결해제")
            }
        }
    }
    
    /// 보내기 버튼
    var sendBtn: some View {
        VStack {
            Button {
                print("MainView - sendBtn() click")
                // 보내기
//                sendKlay()
                testSend()
            } label: {
                Text("보내기")
            }

        }
    }
    
    func testSend() {
        print("MainView - testSend() called")
        
    }
    
    /// 클레이튼 전송
    func sendKlay() {
        print("MainView - sendKlay() call")
        try? viewModel.walletConnect.client.send(nonceRequest()) { /*[weak self]*/ response in
//            guard let self = self, let nonce = self.nonce(from: response) else { return }
//            let transaction = Stub.transaction(from: self.viewModel.walletConnect.session.walletInfo!.accounts[0], nonce: nonce)
//            try? self.viewModel.walletConnect.client.
            
            
            let transaction = Stub.transaction(from: self.viewModel.walletConnect.session.walletInfo!.accounts[0], nonce: self.nonce(from: response) ?? "nil_nil")
//            try? self.viewModel.walletConnect.client.
        }
    }
    
    private func nonce(from response: Response) -> String? {
        return try? response.result(as: String.self)
    }
    
    private func nonceRequest() -> Request {
        return .getTransactionCount(url: viewModel.walletConnect.session.url, account: viewModel.walletConnect.session.walletInfo!.accounts[0])
    }
    
//    public func klay_sendTransaction(url: WCURL, transaction: Transaction, completion: @escaping RequestResponse) throws {
//        print("MainView - klay_sendTransaction() called")
//        try handle
//    }
//
//    public func handleTransaction(url: WCURL, method: String, transaction: Transaction, completion: @escaping RequestResponse) throws {
//        let request = try Request(url: url, method: method, namedParams: [transaction])
//        try send
//    }
    
    static func transaction(from address: String, nonce: String, chainId: String) -> Client.Transaction {
        print("MainView - transaction() called - address = \(address), nonce = \(nonce), chainId = \(chainId)")
        return Client.Transaction(from: address,
                                  to: "0xF15c98458AD61a1DCfb41f3B2747bD7D86B27C0a",
                                  data: "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675",
                                  gas: nil,
                                  gasPrice: nil,
                                  value: "",
                                  nonce: nonce,
                                  type: nil,
                                  accessList: nil,
                                  chainId: chainId,
                                  maxPriorityFeePerGas: nil,
                                  maxFeePerGas: nil)
    }
}


// MARK: - Request
extension Request {
    static func getTransactionCount(url: WCURL, account: String) -> Request {
        return try! Request(url: url, method: "klay_getTransactionCount", namedParams: [account, "latest"])
    }
}
