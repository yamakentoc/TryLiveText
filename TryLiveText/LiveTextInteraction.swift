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
    var targetImage: UIImage?
    /// 画像を解析するオブジェクト
    let analyzer = ImageAnalyzer()
    /// 画像を含むViewのためのLiveTextInteraction
    let interaction = ImageAnalysisInteraction()
    
    func makeUIView(context: Context) -> some UIView {
        let imageView = LiveTextImageView()
        imageView.image = targetImage
        imageView.contentMode = .scaleAspectFit
        imageView.addInteraction(interaction)
        // imageViewをviewに入れないと画像を変更しても更新されない
        // 参考：https://stackoverflow.com/questions/66442591/update-image-in-uiimageview
        let view = UIView()
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // 前回の結果をクリアする
        interaction.prepareForInterfaceBuilder()
        interaction.analysis = nil

        guard let targetImage = targetImage else { return }
        if let imageView = uiView.subviews.first as? LiveTextImageView {
            imageView.image = targetImage
        }
        Task {
            // 解析対象をテキストのみに絞る
            let configuration = ImageAnalyzer.Configuration([.text])
            do {
                let analysis = try await analyzer.analyze(targetImage, configuration: configuration)
                interaction.analysis = analysis
                detectedText = analysis.transcript
                print("検出: \(detectedText)")
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
