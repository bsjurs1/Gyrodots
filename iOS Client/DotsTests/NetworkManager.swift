//
//  NetworkManager.swift
//  Dots
//
//  Created by Bjarte Sjursen on 30.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static func registerUser(_ username : String, password : String, completionHandler : @escaping (_ data : Data?, _ response : URLResponse?, _ error : NSError?) -> Void){
        do{
            let urlRequest = NSMutableURLRequest(url: URL(string: apiWebAddress + "register")!)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let post = ["username":username, "password":password]
            let postData = try JSONSerialization.data(withJSONObject: post, options: .prettyPrinted)
            urlRequest.httpBody = postData
            dispatchURLRequest(urlRequest, completionHandler: completionHandler)
        } catch{
            print("Could not construct the necessary data")
        }
    }
    
    static func dispatchURLRequest(_ urlRequest : NSMutableURLRequest, completionHandler : @escaping (_ data : Data?, _ response : URLResponse?, _ error : NSError?) -> Void){
        DispatchQueue(label: "My Queue",attributes: []).async(execute: {
			
            URLSession.shared.dataTask(with: urlRequest.url!, completionHandler: { (data, response, error) -> Void in
				completionHandler(data, response, error! as NSError)
            }).resume()
            
        })
    }
    
    static func login(_ username : String, password : String, completionHandler : @escaping (_ data : Data?, _ response : URLResponse?, _ error : NSError?) -> Void){
        do{
            let urlRequest = NSMutableURLRequest(url: URL(string: apiWebAddress + "login")!)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let post = ["username": username, "password": password]
            let postData = try JSONSerialization.data(withJSONObject: post, options: .prettyPrinted)
            urlRequest.httpBody = postData
            dispatchURLRequest(urlRequest, completionHandler: completionHandler)
        } catch{
            print("Could not construct the necessary data")
        }
    }
    
    static func setScore(_ username : String, score : Int, token : String, completionHandler : @escaping (_ data : Data?, _ response : URLResponse?, _ error : NSError?) -> Void){
        do{
            let urlRequest = NSMutableURLRequest(url: URL(string: apiWebAddress + "scores")!)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let post = ["username":"\(username)", "score":score] as [String : Any]
            let postData = try JSONSerialization.data(withJSONObject: post, options: .prettyPrinted)
            urlRequest.httpBody = postData
            dispatchURLRequest(urlRequest, completionHandler: completionHandler)
        } catch{
            print("Could not construct the necessary JSON data")
        }
    }
    
    static func updateScore(_ username : String, score : Int, token : String, completionHandler : @escaping (_ data : Data?, _ response : URLResponse?, _ error : NSError?) -> Void){
        do {
            let urlRequest = NSMutableURLRequest(url: URL(string: "https://ancient-bayou-30423.herokuapp.com/api/scores/")!)
            urlRequest.httpMethod = "PUT"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let post = ["username":"\(username)", "score": score] as [String : Any]
            let postData = try JSONSerialization.data(withJSONObject: post, options: .prettyPrinted)
            urlRequest.httpBody = postData
            dispatchURLRequest(urlRequest, completionHandler: completionHandler)
        } catch {
            print("Could not construct the necessary JSON data")
        }
    }
    
    static func deleteScore(_ username : String, token : String, completionHandler : @escaping (_ data : Data?, _ response : URLResponse?, _ error : NSError?) -> Void){
        do {
            let urlRequest = NSMutableURLRequest(url: URL(string: "https://ancient-bayou-30423.herokuapp.com/api/scores/")!)
            urlRequest.httpMethod = "DELETE"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let post = ["username":"\(username)"]
            let postData = try JSONSerialization.data(withJSONObject: post, options: .prettyPrinted)
            urlRequest.httpBody = postData
            dispatchURLRequest(urlRequest, completionHandler: completionHandler)
        } catch {
            
        }
    }
    
    static func getScores(_ completionHandler : @escaping (_ data : Data?, _ response : URLResponse?, _ error : NSError?) -> Void){
        let urlRequest = NSMutableURLRequest(url: URL(string: apiWebAddress + "scores")!)
        urlRequest.httpMethod = "GET"
        dispatchURLRequest(urlRequest, completionHandler: completionHandler)
    }
    
    static func getScore(_ username : String, token : String, completionHandler : @escaping (_ data : Data?, _ response : URLResponse?, _ error : NSError?) -> Void){
        
        let urlRequest = NSMutableURLRequest(url: URL(string: "https://ancient-bayou-30423.herokuapp.com/api/getScore")!)
        
        do{
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let post = ["username":"\(username)"]
            let postData = try JSONSerialization.data(withJSONObject: post, options: .prettyPrinted)
            urlRequest.httpBody = postData
            dispatchURLRequest(urlRequest, completionHandler: completionHandler)
        }
        catch {
            print("error")
        }
    }
    
    static func deleteUser(_ username : String, password : String, token : String, completionHandler : @escaping (_ data : Data?, _ response : URLResponse?, _ error : NSError?) -> Void){
        do {
            let urlRequest = NSMutableURLRequest(url: URL(string: "https://ancient-bayou-30423.herokuapp.com/api/deleteUser")!)
            urlRequest.httpMethod = "DELETE"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let post = ["username":"\(username)", "password":"\(password)"]
            let postData = try JSONSerialization.data(withJSONObject: post, options: .prettyPrinted)
            urlRequest.httpBody = postData
            dispatchURLRequest(urlRequest, completionHandler: completionHandler)
        } catch {
            print("Could not delete user")
        }
    }
    
    
}
