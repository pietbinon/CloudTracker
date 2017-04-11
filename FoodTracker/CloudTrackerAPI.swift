//
//  CloudTrackerAPI.swift
//  FoodTracker
//
//  Created by Pierre Binon on 2017-04-11.
//  Copyright © 2017 Pierre Binon. All rights reserved.
//

import UIKit

class CloudTrackerAPI: NSObject {
    
    
    public func postRequest(postData : [String:String], completion: @escaping ([String:[String:String]]) -> Void) {
        guard let postJSON = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
            print("could not serialize json")
            return
        }
        
        let req = NSMutableURLRequest(url: URL(string:"http://159.203.243.24:8000/signup")!)
        
        req.httpBody = postJSON
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: req as URLRequest) { (data, resp, err) in
            
            guard let data = data else {
                print("no data returned from server \(err)")
                return
            }
            
            guard let resp = resp as? HTTPURLResponse else {
                print("no response returned from server \(err)")
                return
            }
            
            guard let rawJSON = try? JSONSerialization.jsonObject(with: data, options: []) else {
                print("data returned is not json, or not valid")
                return
            }
            
            guard resp.statusCode == 200 else {
                // handle error
                print("an error occurred")
                return
            }
            
            completion(rawJSON as! [String : [String : String]])
            
        }
        
        task.resume()
        
    }
    
    func post(data: [String: AnyObject], toEndpoint: String, completion: @escaping (Data?, NSError?)->(Void)){
        guard let postJSON = try? JSONSerialization.data(withJSONObject: data, options: []) else {
            print("could not serialize json")
            return
        }
        print(postJSON)
        let string = toEndpoint
        let req = NSMutableURLRequest(url: URL(string:"http://159.203.243.24:8000/\(string)")!)
        print("http://159.203.243.24:8000/\(string)")
        req.httpBody = postJSON
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: req as URLRequest) { (data, resp, err) in
            
            guard let data = data else {
                print("no data returned from server \(err)")
                return
            }
            
            guard let resp = resp as? HTTPURLResponse else {
                print("no response returned from server \(err)")
                return
            }
            
            guard resp.statusCode == 200 else {
                // handle error
                print("an error occurred")
                return
            }
            
            completion(data,err as NSError?)
            
        }
        
        task.resume()
        
        
    }
    
    func saveMeal(meal: Meal, completion: @escaping (NSError?)->(Void)){
        let upload = meal
        let req = NSMutableURLRequest(url: URL(string:"http://159.203.243.24:8000/users/me/meals/:id/photo")!)
        guard let photo = upload.photo else{
            return
        }
        guard let data = UIImagePNGRepresentation(photo) else{
            return
        }
        req.httpBody = data
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: req as URLRequest) { (data, resp, err) in
            
            guard let data = data else {
                print("no data returned from server \(err)")
                return
            }
            
            guard let resp = resp as? HTTPURLResponse else {
                print("no response returned from server \(err)")
                return
            }
            guard resp.statusCode == 200 else {
                // handle error
                print("an error occurred")
                return
            }
            
            completion(err as NSError?)
            
        }
        
        task.resume()
    }    
}
