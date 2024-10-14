//
//  UIImage+Extension.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/14/24.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("이미지 로드 실패: \(error.localizedDescription)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("유효하지 않은 이미지 데이터")
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
