//
//  PhotoLibraryPicker.swift
//  TryLiveText
//
//  Created by 山口賢登 on 2022/08/09.
//

import SwiftUI
import PhotosUI
///  フォトライブラリから画像を取得する
struct PhotoLibraryPicker: UIViewControllerRepresentable {
    /// Viewを閉じるためのプロパティ
    @Environment(\.dismiss) var dismiss
    /// 選択した写真
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> some PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        let parent: PhotoLibraryPicker
        
        init(_ parent: PhotoLibraryPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dismiss()
            guard let image = results.first else { return }
            image.itemProvider.loadObject(ofClass: UIImage.self) { selectedImage, error in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                }
                guard let selectedImage = selectedImage as? UIImage else { return }
                self.parent.selectedImage = selectedImage
            }
        }
        
    }
    
    
}
