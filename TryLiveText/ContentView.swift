//
//  ContentView.swift
//  TryLiveText
//
//  Created by 山口賢登 on 2022/08/07.
//

import SwiftUI
import VisionKit

struct ContentView: View {
    /// 写真から検出したテキスト
    @State var detectedText = ""
    /// PhotoLibraryPickerを表示するか
    @State var isShowPhotoLibraryPicker = false
    /// CameraImagePickerを表示するか
    @State var isShowCameraImagePicker = false
    /// 表示する写真
    @State var selectedImage: UIImage?
    /// LiveTextをサポートしている端末か
    @State var isLiveTextSupport = false
    /// LiveTextをサポートしてない場合のアラートを表示するか
    @State var isShowAlert = false
    
    var body: some View {
        VStack {
            LiveTextInteraction(detectedText: $detectedText, targetImage: $selectedImage)
            ScrollView(.vertical, showsIndicators: true) {
                Text("検出した文字:\n")
                    .bold()
                Text(detectedText)
                    .foregroundColor(.green)
            }
            .frame(maxWidth: .infinity)
            // 読み込みボタン
            Button(action: {
                if !isLiveTextSupport {
                    isShowAlert = true
                }
                isShowPhotoLibraryPicker.toggle()
            }) {
                Text("ライブラリから写真選択")
            }
            Spacer().frame(height: 20)
            Button(action: {
                if !isLiveTextSupport {
                    isShowAlert = true
                }
                isShowCameraImagePicker.toggle()
            }) {
                Text("カメラで撮影")
            }
        }
        .padding()
        .onAppear {
            isLiveTextSupport = ImageAnalyzer.isSupported
        }
        .sheet(isPresented: $isShowPhotoLibraryPicker) {
            PhotoLibraryPicker(selectedImage: $selectedImage)
        }
        .sheet(isPresented: $isShowCameraImagePicker) {
            CameraImagePicker(selectedImage: $selectedImage)
        }
        .alert("Lite Textをサポートしてません", isPresented: $isShowAlert, actions: {})
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
