//
//  UIImage+ Extention.swift
//  NotesApp
//
//  Created by Vladislav Avrutin on 02.09.2025.
//

import UIKit
extension UIImage {
    func resize(targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    func resize(to size: CGFloat) -> UIImage? {
        return resize(targetSize: CGSize(width: size, height: size))
    }
}
