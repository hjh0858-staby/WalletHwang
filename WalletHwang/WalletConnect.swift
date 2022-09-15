//
//  WalletConnect.swift
//  WalletHwang
//
//  Created by 황재현 on 2022/08/31.
//

import SwiftUI
import WalletConnectSwift

/// 프로토콜
protocol WalletConnectDelegate {
    /// 연결 실패
    func failedToConnect()
    /// 연결 되었다
    func didConnect()
    /// 연결 끊겼다
    func didDisconnect()
}

class WalletConnect {
    var client: Client!
    var session: Session!
    var delegate: WalletConnectDelegate
    
    let sessionKey: String = "sessionKey"
    
    // MARK: - init
    init(delegate: WalletConnectDelegate) {
        self.delegate = delegate
    }
}

// MARK: - Method
extension WalletConnect {
    /// 연결
    func connect() -> String {
        let wcUrl = WCURL(topic: UUID().uuidString, bridgeURL: URL(string: "https://safe-walletconnect.gnosis.io/")!, key: try! randomKey())
        let clientMeta = Session.ClientMeta(name: "ExampleDApp", description: "WalletConnectSwift", icons: [], url: URL(string: "https://safe.gnosis.io")!)
        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
        
        client = Client(delegate: self, dAppInfo: dAppInfo)
        
        try! client.connect(to: wcUrl)
        return wcUrl.absoluteString
    }
    
    /// 재연결
    func reconnectIfNeeded() {
        if let oldSessionObject = UserDefaults.standard.object(forKey: sessionKey) as? Data, let session = try? JSONDecoder().decode(Session.self, from: oldSessionObject) {
            client = Client(delegate: self, dAppInfo: session.dAppInfo)
            try? client.reconnect(to: session)
        }
    }
    
    /// 랜덤키 생성
    func randomKey() throws -> String {
        var bytes = [Int8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            return Data(bytes: bytes, count: 32).toHexString()
        } else {
            enum TestError: Error {
                case unknow
            }
            throw TestError.unknow
        }
    }
}

extension WalletConnect: ClientDelegate {
    func client(_ client: Client, didFailToConnect url: WCURL) {
        delegate.failedToConnect()
    }

    func client(_ client: Client, didConnect url: WCURL) {
        // do nothing
    }

    func client(_ client: Client, didConnect session: Session) {
        self.session = session
        let sessionData = try! JSONEncoder().encode(session)
        UserDefaults.standard.set(sessionData, forKey: sessionKey)
        delegate.didConnect()
    }

    func client(_ client: Client, didDisconnect session: Session) {
        UserDefaults.standard.removeObject(forKey: sessionKey)
        delegate.didDisconnect()
    }

    func client(_ client: Client, didUpdate session: Session) {
        // do nothing
    }
}
