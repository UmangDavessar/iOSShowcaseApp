//
//  MovieServices.swift
//  iOSShowcaseApp
//
//  Created by Umang Davessar on 3/6/19.
//  Copyright © 2019 Umang Davessar. All rights reserved.
//

import Foundation
import Alamofire

public class MovieServices: NSObject
{
    
    private let apiKey = "f8636ae8be13555ff63f171bbfc594c9"
    private let baseURL = "https://api.themoviedb.org/3/movie"
    
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    
    //MARK: - FETCH MOVIES LIST _ NOW PLAYING
    open func getMoviesList(_ movieCat: String, success:@escaping (_ moviesList: MovieListResponse)-> Void, failure:@escaping (_ error: RZError?)-> Void) -> Void {
        
        let url = URL(string: "\(baseURL)/\(movieCat)/?api_key=\(apiKey)")
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpMethod = "GET"
        
        Alamofire.request(xmlRequest)
            .responseData { (response) in
                let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                debugPrint(stringResponse)
                
                var statusCode = 0
                
                if(response.response != nil){
                    statusCode = (response.response?.statusCode)!
                    
                }
                
                
                if (response.result.isSuccess) {
                    
                    if statusCode >= 200 && statusCode < 300 {
                        
                        do {
                            
                            let moviesResponse = try self.jsonDecoder.decode(MovieListResponse.self, from: response.data!)
                            DispatchQueue.main.async {
                                success(moviesResponse)
                            }
//
                        } catch let err{
                            print(err.localizedDescription)
                        }
                        
                    }
                    else if statusCode == 500 { // Handling internal server error
                        print("Internal server error")
                        failure(RZError(error: nil, customeMessage: response.error?.localizedDescription))
                        
                    }
                    else if statusCode == 401 {
                        // Unauthorized
                        failure(RZError(error: nil, customeMessage: response.error?.localizedDescription))
                    }
                    else {
                        failure(nil)
                    }
                    
                }
                else {
                    print("\(#function)::response.result.debugDescription->\(String(describing: response.error?.localizedDescription))")
                    failure(RZError(error: nil, customeMessage: response.error?.localizedDescription))
                    
                    
                    
                }
        }
        
        
    }
    
    //MARK: - FETCH MOVIE DETAILS
    
    open func getMoviesDetail(_ movieID: Int,success:@escaping (_ moviesList: MovieListKeys)-> Void, failure:@escaping (_ error: RZError?)-> Void) -> Void {
        
        
        
        let url = URL(string: "\(baseURL)/\(movieID)?api_key=\(apiKey)")
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpMethod = "GET"
        
        Alamofire.request(xmlRequest)
            .responseData { (response) in
                let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                debugPrint(stringResponse)
                
                var statusCode = 0
                
                if(response.response != nil){
                    statusCode = (response.response?.statusCode)!
                    
                }
                
                
                if (response.result.isSuccess) {
                    
                    if statusCode >= 200 && statusCode < 300 {
                        
                        do
                        {
                        let moviesResponse = try self.jsonDecoder.decode(MovieListKeys.self, from: response.data!)
                        DispatchQueue.main.async {
                            success(moviesResponse) }
                        } catch let err{
                            print(err.localizedDescription)
                        }
                        
                    }
                    else if statusCode == 500 { // Handling internal server error
                        print("Internal server error")
                       failure(RZError(error: nil, customeMessage: response.error?.localizedDescription))
                        
                    }
                    else if statusCode == 401 {
                        // Unauthorized
                        failure(RZError(error: nil, customeMessage: response.error?.localizedDescription))
                    }
                    else {
                        failure(nil)
                    }
                    
                }
                else {
                    print("\(#function)::response.result.debugDescription->\(String(describing: response.error?.localizedDescription))")
                    failure(RZError(error: nil, customeMessage: response.error?.localizedDescription))
                    
                    
                    
                }
        }
        
        
    }
    
    
    private func handleError(errorHandler: @escaping(_ error: Error) -> Void, error: Error) {
        DispatchQueue.main.async {
            errorHandler(error)
        }
    }
    
}

