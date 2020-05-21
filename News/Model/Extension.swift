//
//  Extension.swift
//  News
//
//  Created by Roman Topchii on 21.05.2020.
//  Copyright © 2020 Roman Topchii. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView {
    func load(url: URL, placeholder: UIImage?, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            AF.request(url).responseData { (response) in
                if let data = response.value, let image = UIImage(data: data), let response = response.response{
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    self.image = image
                }
            }
        }
    }
}
