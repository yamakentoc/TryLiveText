//
//  ContentView.swift
//  TryLiveText
//
//  Created by 山口賢登 on 2022/08/07.
//

import SwiftUI
import VisionKit

/// 画面遷移に関わるデータを管理
class RouteData: ObservableObject {
    /// アクションシートを表示するか
    @Published var isShowActionSheet = false
    /// PhotoLibraryPickerを表示するか
    @Published var isShowPhotoLibraryPicker = false
    /// CameraImagePickerを表示するか
    @Published var isShowCameraImagePicker = false
    /// LiveTextをサポートしてない場合のアラートを表示するか
    @State var isShowAlert = false
}

/// 表示するView
struct ContentView: View {
    /// 写真から検出したテキスト
    @State var detectedText = ""
    /// 表示する写真
    @State var selectedImage: UIImage?
    /// LiveTextをサポートしている端末か
    @State var isLiveTextSupport = false
    /// 画面遷移に関わるデータ
    @ObservedObject var routeData: RouteData
    
    var body: some View {
        VStack {
            LiveTextInteraction(detectedText: $detectedText, targetImage: selectedImage)
            ScrollView(.vertical, showsIndicators: true) {
                Text("検出した文字:\n")
                    .bold()
                Text(detectedText)
                    .foregroundColor(.green)
            }
            .frame(maxWidth: .infinity)
            // 読み込みボタン
            Button(action: {
                routeData.isShowPhotoLibraryPicker.toggle()
            }) {
                Text("ライブラリから写真選択")
            }
            Spacer().frame(height: 20)
            Button(action: {
                routeData.isShowCameraImagePicker.toggle()
            }) {
                Text("カメラで撮影")
            }
        }
        .padding()
        .onAppear {
            isLiveTextSupport = ImageAnalyzer.isSupported
            if !isLiveTextSupport {
                routeData.isShowAlert = true
            }
        }
        .sheet(isPresented: $routeData.isShowPhotoLibraryPicker) {
            PhotoLibraryPicker(selectedImage: $selectedImage)
        }
        .sheet(isPresented: $routeData.isShowCameraImagePicker) {
            CameraImagePicker(selectedImage: $selectedImage)
        }
        .alert("Lite Textをサポートしてません", isPresented: $routeData.isShowAlert, actions: {})
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(routeData: RouteData())
    }
}
