//
//  NewsFetchManager.swift
//  TestWorkNewsApp
//
//  Created by Anastasia on 8/23/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NewsFetchManager: NSObject {
    private let apiKey = "0d85e6cf2c5f4807965098ff95e3e20d"
    
    func generateURL(searchPhrase: String?, categoryType: String?, languageType: String? , countryType: String?, completionHandler: @escaping (_ result: [NewsArticle]?, _ error: String?) -> Void){
        var url = "https://newsapi.org/v2/"
        var typeOfSorting = "articles"
        if let phrase = searchPhrase{
            url = url + "everything?q=\(phrase)&"
            if categoryType != nil || languageType != nil || countryType != nil {
                if let category = categoryType  {
                    url = url + "category=\(category)&"
                }
                if let language = languageType {
                    url = url + "language=\(language)&"
                }
                if let country = countryType {
                    url = url + "country=\(country)&"
                }
            }
            url = url + "sortBy=publishedAt&apiKey=\(apiKey)"
            print(url)
            sendRequest(url: url, typeOfSorting: typeOfSorting) { (response, error) in
                completionHandler(response, error)
            }
        } else if categoryType != nil || languageType != nil || countryType != nil {
            typeOfSorting = "sources"
            url = url + "sources?"
            if let category = categoryType  {
                url = url + "category=\(category)&"
            }
            if let language = languageType {
                url = url + "language=\(language)&"
            }
            https://newsapi.org/v2/sources?category=business&sortBy=publishedAt&apiKey=0d85e6cf2c5f4807965098ff95e3e20d
            
            if let country = countryType {
                url = url + "country=\(country)&"
            }
            url = url + "sortBy=publishedAt&apiKey=\(apiKey)"
            print(url)
            sendRequest(url: url, typeOfSorting: typeOfSorting) { (response, error) in
                completionHandler(response, error)
            }
        } else {
            url = "https://newsapi.org/v2/top-headlines?q=Apple&apiKey=\(apiKey)"
            sendRequest(url: url, typeOfSorting: typeOfSorting) { (response, error) in
                completionHandler(response, error)
            }
        }
    }
    
    
    func sendRequest(url: String, typeOfSorting: String, completionHandler: @escaping (_ result: [NewsArticle]?, _ error: String?) -> Void){
        Alamofire.request(url).responseJSON { response in
            if response.result.isSuccess {
                if let resp = response.result.value {
                    let resultTuple = self.parseJSON(json: JSON(resp), typeOfSorting: typeOfSorting)
                    let resultArray = resultTuple.0
                    let error: String? = resultTuple.errorMessage
                    completionHandler(resultArray, error)
                }
            } else {
                if let resp = response.result.value{
                    let error = self.parseJSON(json: JSON(resp), typeOfSorting: typeOfSorting).errorMessage
                    let resultArray = self.parseJSON(json: JSON(resp), typeOfSorting: typeOfSorting).0
                    completionHandler(resultArray, error)
                }
            }
            
        }
    }

    
    func parseJSON(json : JSON, typeOfSorting: String) -> ([NewsArticle], errorMessage : String?) {
        var resultArray = [NewsArticle]()
            var articleIndex = 0
            if typeOfSorting == "articles"{
                while articleIndex < json[typeOfSorting].count {
                    let article = NewsArticle()
                    article.source = json[typeOfSorting][articleIndex]["source"]["name"].stringValue
                    article.author = json[typeOfSorting][articleIndex]["author"].stringValue
                    article.title =  json[typeOfSorting][articleIndex]["title"].stringValue
                    article.description = json[typeOfSorting][articleIndex]["description"].stringValue
                    article.urlToImage = json[typeOfSorting][articleIndex]["urlToImage"].stringValue
                    article.url = json[typeOfSorting][articleIndex]["url"].stringValue
                    resultArray.append(article)
                    
                    articleIndex+=1
                }
            } else {
                while articleIndex < json[typeOfSorting].count {
                    let article = NewsArticle()
                    article.title = json[typeOfSorting][articleIndex]["name"].stringValue
                    article.description = json[typeOfSorting][articleIndex]["description"].stringValue
                    article.url = json[typeOfSorting][articleIndex]["url"].stringValue
                    resultArray.append(article)
                    
                    articleIndex+=1
                }
            }
        return (resultArray, json["message"].stringValue)
    }
}

