//
//  LiveTextInteraction.swift
//  TryLiveText
//
//  Created by 山口賢登 on 2022/08/08.
//

import UIKit
import SwiftUI
import VisionKit

@MainActor
struct LiveTextInteraction: UIViewRepresentable {
    /// 検出したテキスト
    @Binding var detectedText: String
    /// 解析対象の画像
    @Binding var targetImage: UIImage?
    /// ImageView
    let imageView = LiveTextImageView()
    /// 画像を解析するオブジェクト
    let analyzer = ImageAnalyzer()
    /// 画像を含むViewのためのLiveTextInteraction
    let interaction = ImageAnalysisInteraction()
    
    func makeUIView(context: Context) -> some UIView {
        imageView.image = targetImage
        imageView.addInteraction(interaction)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        Task {
            // 解析対象をテキストのみに絞る
            let configuration = ImageAnalyzer.Configuration([.text])
            do {
                if let image = targetImage {
                    let analysis = try await analyzer.analyze(image, configuration: configuration)
                    interaction.analysis = analysis
                    detectedText = analysis.transcript
                    imageView.image = targetImage
                    print("検出: \(detectedText)")
                }
            } catch {
                print("error")
            }
        }
    }
    
}


class LiveTextImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        .zero
    }
}
