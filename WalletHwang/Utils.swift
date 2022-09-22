//
//  Utils.swift
//  WalletHwang
//
//  Created by 황재현 on 2022/09/21.
//

import Foundation
import WalletConnectSwift

enum Stub {
    /// https://docs.walletconnect.org/json-rpc-api-methods/ethereum#example-parameters
    static let typedData = """
{
    "types": {
        "EIP712Domain": [
            {
                "name": "name",
                "type": "string"
            },
            {
                "name": "version",
                "type": "string"
            },
            {
                "name": "chainId",
                "type": "uint256"
            },
            {
                "name": "verifyingContract",
                "type": "address"
            }
        ],
        "Person": [
            {
                "name": "name",
                "type": "string"
            },
            {
                "name": "wallet",
                "type": "address"
            }
        ],
        "Mail": [
            {
                "name": "from",
                "type": "Person"
            },
            {
                "name": "to",
                "type": "Person"
            },
            {
                "name": "contents",
                "type": "string"
            }
        ]
    },
    "primaryType": "Mail",
    "domain": {
        "name": "Ether Mail",
        "version": "1",
        "chainId": 1,
        "verifyingContract": "0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC"
    },
    "message": {
        "from": {
            "name": "Cow",
            "wallet": "0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826"
        },
        "to": {
            "name": "Bob",
            "wallet": "0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB"
        },
        "contents": "Hello, Bob!"
    }
}
"""

    /// https://docs.walletconnect.org/json-rpc-api-methods/ethereum#example-parameters-1
    static func transaction(from address: String, nonce: String) -> Client.Transaction {
        print("transaction() called - address = \(address)")
        return Client.Transaction(from: address,
                                  to: "0xF15c98458AD61a1DCfb41f3B2747bD7D86B27C0a",
                                  data: "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675",
                                  gas: nil,
                                  gasPrice: nil,
                                  value: "",
                                  nonce: nonce,
                                  type: nil,
                                  accessList: nil,
                                  chainId: "1001",
                                  maxPriorityFeePerGas: nil,
                                  maxFeePerGas: nil)
    }

    /// https://docs.walletconnect.org/json-rpc-api-methods/ethereum#example-5
    static let data = "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f07244567"

}
