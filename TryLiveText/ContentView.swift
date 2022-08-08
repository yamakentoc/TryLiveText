//
//  ContentView.swift
//  TryLiveText
//
//  Created by 山口賢登 on 2022/08/07.
//

import SwiftUI

struct ContentView: View {
    // ImagePickerを表示するかどうか
    @State var isShowImagePicker = false
    // 表示する写真
    @State var selectedImage: UIImage = UIImage(systemName: "photo")!
    
    var body: some View {
        VStack {
            Button(action: {
                isShowImagePicker.toggle()
            }) {
                Text("ライブラリから写真選択")
            }
            Spacer().frame(height: 20)
            Button(action: {
                
            }) {
                Text("カメラで撮影")
            }
        }
        .sheet(isPresented: $isShowImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
