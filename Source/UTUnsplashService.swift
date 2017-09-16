//
//  UTUnsplashService.swift
//  UTUnsplash
//
//  Created by Edward MORGAN on 9/7/17.
//  Copyright © 2017 Mert YILDIZ. All rights reserved.
//

import Foundation

class UTUnsplashService : NSObject {
    
    var adress = "https://api.unsplash.com/"
    
    public func getPhotoes(applicationKey:String,page:Int ,completion: @escaping (_ success: Bool, _ object: NSArray?) -> ()) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let params = "?page=" + page.description + "&client_id=" + applicationKey
        let url = NSURL(string: adress + "photos" + params)
        var request = URLRequest(url: url! as URL)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) {
            data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                if json == nil {
                    completion(false, nil)
                }
                else{
                    completion(true, json as! NSArray?)
                }
            }
            if (error != nil) {
                completion(false, nil)
            }
        }
        task.resume()
    }
    public func getQueryPhotoes(applicationKey:String,page:Int,query:String ,completion: @escaping (_ success: Bool, _ object: NSArray?) -> ()) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let params = "?page=" + page.description + "&query=" + query + "&client_id=" + applicationKey
        let url = NSURL(string: adress + "search/photos" + params)
        var request = URLRequest(url: url! as URL)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) {
            data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)as? NSDictionary
                if json == nil {
                    completion(false, nil)
                }
                else{
                    completion(true, json??.value(forKey: "results") as? NSArray)
                }
            }
            if (error != nil) {
                completion(false, nil)
            }
        }
        task.resume()
    }

}
