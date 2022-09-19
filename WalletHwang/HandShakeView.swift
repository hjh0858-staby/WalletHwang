//
//  HandShakeView.swift
//  WalletHwang
//
//  Created by 황재현 on 2022/08/31.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import AVFoundation


/// QR코드 로그인 뷰
struct HandShakeView: View {
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
            
            Image(uiImage: makeQrCode(code: code))
            
            Button {
                print("QRCode - code = \(code)")
            } label: {
                Text("코드 값은?")
            }

            
            Spacer()
        }
    }
    
    func makeQrCode(code: String) -> UIImage {
        let data = Data(code.utf8)
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        
        let outputImage = filter.outputImage!
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 4, y: 4))
        let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent)!
        
        return UIImage(cgImage: cgImage)
    }
}
