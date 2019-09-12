//
//  NetworkManager.swift
//  Survision
//
//  Created by Jeremy Ben-Meir on 8/15/19.
//  Copyright © 2019 Jeremy Ben-Meir. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    private static let endpoint = "http://⁠⁦‪35.221.58.124‬⁩/api"
    
    static func signUp(firstName: String, lastName: String, email: String, completion: @escaping (User) -> Void) {
        let parameters: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
        ]
        Alamofire.request("\(endpoint)/user/signup/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData
            { (response) in
                switch response.result {
                case .success(let data):
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                        //print(json)
                    }
                    let jsonDecoder = JSONDecoder()
                    if let response = try? jsonDecoder.decode(CreateUserResponse.self, from: data) {
                        completion(response.data)
                        //print("received user with id \(response.data.id)")
                    } else {
                        print("ADD USER Invalid Response Data")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("ADD USER FAILURE")
                }
        }
    }
    
    static func getUser(email: String, completion: @escaping (User?) -> Void) {
        Alamofire.request("\(endpoint)/getuser/\(email)", method: .get).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    //print(json)
                }
                let jsonDecoder = JSONDecoder()
                if let response = try? jsonDecoder.decode(GetUserResponse.self, from: data) {
                    completion(response.data)
                } else {
                    print("GET USERInvalid Response Data")
                }
            case .failure(let error):
                print(error.localizedDescription)
                print("GET USER FAILURE")
                completion(nil)
            }
        }
    }
    
    static func getPhotos(id: Int, completion: @escaping ([Tree]) -> Void) {
        Alamofire.request("\(endpoint)/user/getphotos/\(id)", method: .get).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    //print(json)
                }
                let jsonDecoder = JSONDecoder()
                if let response = try? jsonDecoder.decode(GetTreesResponse.self, from: data) {
                    completion(response.data)
                } else {
                    print("GET USERInvalid Response Data")
                }
            case .failure(let error):
                print(error.localizedDescription)
                print("GET USER FAILURE")
                //completion(nil)
            }
        }
    }
    
//    static func getSurveys(completion: @escaping ([IndSurvey]?) -> Void) {
//        Alamofire.request("\(endpoint)/getsurveys/", method: .get).validate().responseData { (response) in
//            switch response.result {
//            case .success(let data):
//                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                    //print(json)
//                }
//                let jsonDecoder = JSONDecoder()
//                if let response = try? jsonDecoder.decode(GetSurveysResponse.self, from: data) {
//                    completion(response.data)
//                } else {
//                    print("GET SURVEYS Invalid Response Data")
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//                print("GET SURVEYS FAILURE")
//                completion(nil)
//            }
//        }
//    }
//
//    static func createSurvey(name: String, image: String, text: [String], answers: [[String]], completion: @escaping (IndSurvey) -> Void) {
//        let parameters: [String: Any] = [
//            "name": name,
//            "image": image,
//            "questions": [
//                "text": text,
//                "answers": answers,
//            ]
//        ]
//        Alamofire.request("\(endpoint)/addsurvey/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData
//            { (response) in
//                switch response.result {
//                case .success(let data):
//                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                        //print(json)
//                    }
//                    let jsonDecoder = JSONDecoder()
//                    if let response = try? jsonDecoder.decode(CreateSurveyResponse.self, from: data) {
//                        completion(response.data)
//                    } else {
//                        print("CREATE SURVEY Invalid Response Data")
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    print("CREATE SURVEY FAILURE")
//                }
//        }
//    }
//
//    static func deleteSurvey(id: Int, completion: @escaping (IndSurvey) -> Void) {
//        Alamofire.request("\(endpoint)/\(id)/", method: .delete).validate().responseData { (response) in
//            switch response.result {
//            case .success(let data):
//                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                    //print(json)
//                }
//                let jsonDecoder = JSONDecoder()
//                if let response = try? jsonDecoder.decode(DeleteSurveyResponse.self, from: data) {
//                    completion(response.data)
//                } else {
//                    print("DELETE SURVEY Invalid Response Data")
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//                print("DELETE SURVEY FAILURE")
//
//            }
//        }
//    }
//
//    static func submitSurvey(useremail: String, answers: [Int], id: Int, completion: @escaping (IndSurvey) -> Void) {
//        let parameters: [String: Any] = [
//            "useremail": useremail,
//            "answers": answers
//        ]
//        Alamofire.request("\(endpoint)/\(id)/submitsurvey/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData
//            { (response) in
//                switch response.result {
//                case .success(let data):
//                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                        //print(json)
//                    }
//                    let jsonDecoder = JSONDecoder()
//                    if let response = try? jsonDecoder.decode(SubmitSurveyResponse.self, from: data) {
//                        completion(response.data)
//                    } else {
//                        print("SUBMIT SURVEY Invalid Response Data")
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    print("SUBMIT SURVEY FAILURE")
//                }
//        }
//    }
//
//    static func addGiftCard(company: String, amount: String, image: String, completion: @escaping (Giftcard) -> Void) {
//        let parameters: [String: Any] = [
//            "company": company,
//            "amount": amount,
//            "image": image
//        ]
//        Alamofire.request("\(endpoint)/addgiftcard/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData
//            { (response) in
//                switch response.result {
//                case .success(let data):
//                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                        //print(json)
//                    }
//                    let jsonDecoder = JSONDecoder()
//                    if let response = try? jsonDecoder.decode(CreateGiftcardResponse.self, from: data) {
//                        completion(response.data)
//                    } else {
//                        print("ADD GIFT CARD Invalid Response Data")
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    print("ADD GIFT CARD FAILURE")
//                }
//        }
//    }
//    static func getGiftcards(completion: @escaping ([Giftcard]?) -> Void) {
//        Alamofire.request("\(endpoint)/viewgiftcards/", method: .get).validate().responseData { (response) in
//            switch response.result {
//            case .success(let data):
//                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                    //print(json)
//                }
//                let jsonDecoder = JSONDecoder()
//                if let response = try? jsonDecoder.decode(GetGiftcardResponse.self, from: data) {
//                    completion(response.data)
//                } else {
//                    print("GET GIFT CARDS Invalid Response Data")
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//                print("GET GIFT CARDS FAILURE")
//                completion(nil)
//            }
//        }
//    }
//    static func chooseWinner(completion: @escaping ([UserShorthand]) -> Void) {
//        Alamofire.request("\(endpoint)/choosewinners/", method: .get).validate().responseData { (response) in
//            switch response.result {
//            case .success(let data):
//                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                    //print(json)
//                }
//                let jsonDecoder = JSONDecoder()
//                if let response = try? jsonDecoder.decode(GetUserShorthandResponse.self, from: data) {
//                    completion(response.data)
//                } else {
//                    print("CHOOSE WINNER Invalid Response Data")
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//                print("CHOOSE WINNER FAILURE")
//            }
//        }
//    }
//    static func deleteGiftcard(company: String, amount: String, completion: @escaping (Giftcard) -> Void) {
//        Alamofire.request("\(endpoint)/deletecard/\(company)/\(amount)/", method: .delete).validate().responseData { (response) in
//            switch response.result {
//            case .success(let data):
//                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                    //print(json)
//                }
//                let jsonDecoder = JSONDecoder()
//                if let response = try? jsonDecoder.decode(CreateGiftcardResponse.self, from: data) {
//                    completion(response.data)
//                } else {
//                    print("DELETE SURVEY Invalid Response Data")
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//                print("DELETE SURVEY FAILURE")
//
//            }
//        }
//    }
}
