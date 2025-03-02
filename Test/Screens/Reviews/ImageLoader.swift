//
//  ImageLoader.swift
//  Test
//
//  Created by Дмитрий Мартьянов on 01.03.2025.
//

import UIKit

typealias ImageCache = NSCache<AnyObject, AnyObject>

final class ImageLoader {
    
    private var cache: ImageCache = ImageCache()
    
    private let loadingQueue: OperationQueue = {
        let loadingQueue = OperationQueue()
        loadingQueue.maxConcurrentOperationCount = 10
        return loadingQueue
    }()
    
    private var loadingOperations: [URL:LoadOperation] = [:]
    
    
    func cancelLoad(by url: String) {
        guard let url = URL(string: url) else {
            return
        }
        if let operation = loadingOperations[url] {
            operation.cancel()
            loadingOperations.removeValue(forKey: url)
        }
    }
    
    func load(by url: String, completion:  ((UIImage?) -> ())?){
        guard let url = URL(string: url) else {
            completion?(nil)
            return
        }
        
        if let image = getChachedImage(url) {
            completion?(image)
            return
        }
        
        let completionHandler: CompletionHandler = { [weak self] image in
            guard let self = self else { return }
            guard let image = image else {
                return
            }
            self.setCachedImage(image: image, url: url)
            loadingOperations.removeValue(forKey: url)
            completion?(image)
            
        }
        
        if let operation = loadingOperations[url] {
            operation.completionHandlers.append(completionHandler)
            return
        }
        let operation = LoadOperation(url: url)
        operation.completionHandlers.append(completionHandler)
        loadingOperations[url] = operation
        loadingQueue.addOperation(operation)
    }
    
    private func getChachedImage(_ url: URL) -> UIImage? {
        return cache.object(forKey: url as AnyObject) as? UIImage
    }
    private func setCachedImage(image: UIImage, url: URL){
        cache.setObject(image as AnyObject, forKey: url as AnyObject)
    }
    
}
