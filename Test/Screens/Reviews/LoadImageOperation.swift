//
//  LoadImageOperation.swift
//  Test
//
//  Created by Дмитрий Мартьянов on 01.03.2025.
//

import UIKit

typealias CompletionHandler = (UIImage?) -> Void
/// Класс, реализующий асинхронную операцию загрузки картинки по URL.
final class LoadOperation: Operation {
    
    var image: UIImage?

    var completionHandlers: [CompletionHandler] = []
    
    private var loadURL: URL
    
    init(url: URL) {
        self.loadURL = url
        super.init()
    }
    
    override func main() {
        URLSession.shared.dataTask(with: loadURL) { [weak self] data, _ , _ in
            DispatchQueue.main.async  { [weak self] in
                guard let self = self else {
                    return
                }
                guard !self.isCancelled,
                let data = data, let image = UIImage(data: data) else {
                    self.handleResult(nil)
                    return
                }
                self.handleResult(image)
            }
        }.resume()
    }
    
    private func handleResult(_ image: UIImage?) {
        self.image = image
        for completion in completionHandlers {
            completion(image)
        }
        completionHandlers.removeAll()
    }
}
