//
//  ImageCache.swift
//  Movies
//
//  Created by Dmitrii Ivanov on 15/09/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit

class ImageCache: NSObject {

    // MARK: - Properties
    static let sharedInstance = ImageCache()

    private let maxImagesInCache = 200
    private var imageCache = [String: UIImage]()
    private var imageStack = [String]()
    private let resourceSyncQueue = DispatchQueue(label: "com.movies.imageCacheSync")

    // MARK: - Public
    func getImage(urlString: String, completion: @escaping (_ image: UIImage?, _ url: String)->()) {
        if let cachedImage = cachedImageForURL(urlString) {
            completion(cachedImage, urlString)
        } else if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    guard let image = UIImage(data: data) else {
                        completion(nil, urlString)
                        return
                    }
                    self.cacheImage(image: image, forURL: urlString)
                    DispatchQueue.main.async() {
                        completion(image, urlString)
                    }
                } catch {
                    print("ImageCache error: \(error.localizedDescription)")
                    DispatchQueue.main.async() {
                        completion(nil, urlString)
                    }
                }
            }
        }
    }

    // MARK: - Private
    private func cacheImage(image: UIImage, forURL url: String) {
        resourceSyncQueue.sync {
            imageCache[url] = image
            imageStack.append(url)
            if imageStack.count > maxImagesInCache {
                let oldestItem = imageStack.removeFirst()
                imageCache.removeValue(forKey: oldestItem)
            }
        }
    }

    private func cachedImageForURL(_ url: String) -> UIImage? {
        var image: UIImage?
        resourceSyncQueue.sync {
            image = imageCache[url]
        }
        return image
    }

    private func clearCache() {
        resourceSyncQueue.sync {
            imageCache.removeAll()
            imageStack.removeAll()
        }
    }
}
