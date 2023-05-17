//
//  APIHub.swift
//  UIUXApps_Assignment
//
//  Created by Sai Naveen Katla on 5/17/23.
//

import Foundation

private let getMealsBaseURL: String = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
private let getMealDetailsBaseURL: String = "https://themealdb.com/api/json/v1/1/lookup.php?i="

final class TheAPIHub {
    
    static let shared = TheAPIHub()
    
    private init() {}
    
    
    private func BASIC_GET<T: Codable>(urlString: String,
                               expecting: T.Type,
                               completion: @escaping(Result<T?, Error>) -> Void)
    {
        guard let url = URL(string: urlString) else {
            return completion(.failure(APIError.invalidURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, res, error in
            if error == nil {
                if let safeData = data {
                    do {
//                        print(try? JSONSerialization.jsonObject(with: safeData, options: []))
                        let finalData = try JSONDecoder().decode(expecting, from: safeData)
                        completion(.success(finalData))
                    }
                    catch {
                        completion(.failure(APIError.invalidDataResponse))
                    }
                }
            }
            else {
                completion(.failure(APIError.error(e: error!.localizedDescription)))
            }
        }.resume()
    }
    
    
    func getAllMeals(completion: @escaping(Result<MealResponse?, Error>) -> Void) {
        BASIC_GET(urlString: getMealsBaseURL,
                  expecting: MealResponse.self) { result in
            completion(result)
        }
    }
    
    func getMealDetails(with id: String, completion: @escaping(Result<MealLookUpResponse?, Error>) -> Void) {
        BASIC_GET(urlString: getMealDetailsBaseURL + id,
                  expecting: MealLookUpResponse.self) { result in
            completion(result)
        }
    }
    
}

enum APIError: Error {
    case invalidURL
    case invalidDataResponse
    case error(e: String)
}

struct MealResponse: Codable {
    var meals: [Meal]?
}

struct Meal: Codable {
    var strMeal: String?
    var strMealThumb: String?
    var idMeal: String?
}

struct MealLookUpResponse: Codable {
    var meals: [MealLookUp]?
}

struct MealLookUp: Codable {
    var idMeal: String?
    var strMeal: String?
    var strDrinkAlternate: String?
    var strCategory: String?
    var strArea: String?
    var strInstructions: String?
    var strMealThumb: String?
    var strTags: String?
    var strYoutube: String?
    var strIngredient1: String?
    var strIngredient2: String?
    var strIngredient3: String?
    var strIngredient4: String?
    var strIngredient5: String?
    var strIngredient6: String?
    var strIngredient7: String?
    var strIngredient8: String?
    var strIngredient9: String?
    var strIngredient10: String?
    var strIngredient11: String?
    var strIngredient12: String?
    var strIngredient13: String?
    var strIngredient14: String?
    var strIngredient15: String?
    var strIngredient16: String?
    var strIngredient17: String?
    var strIngredient18: String?
    var strIngredient19: String?
    var strIngredient20: String?
    var strMeasure1: String?
    var strMeasure2: String?
    var strMeasure3: String?
    var strMeasure4: String?
    var strMeasure5: String?
    var strMeasure6: String?
    var strMeasure7: String?
    var strMeasure8: String?
    var strMeasure9: String?
    var strMeasure10: String?
    var strMeasure11: String?
    var strMeasure12: String?
    var strMeasure13: String?
    var strMeasure14: String?
    var strMeasure15: String?
    var strMeasure16: String?
    var strMeasure17: String?
    var strMeasure18: String?
    var strMeasure19: String?
    var strMeasure20: String?
    var strSource: String?
    var strImageSource: String?
    var strCreativeCommonsConfirmed: String?
    var dateModified: String?
    
    func mapIngredientsToMeasures() -> [(String, String)] {
        var array: [(String, String)] = []
        
        for i in 1...20 {
            let i_key = "strIngredient\(i)"
            let m_key = "strMeasure\(i)"
            
            if let ingredient = self[i_key]?.trimmingCharacters(in: .whitespacesAndNewlines),
               let measure = self[m_key]?.trimmingCharacters(in: .whitespacesAndNewlines),
               ingredient != "",
               measure != "" {
                array.append((ingredient, measure))
            }
        }
        
        return array
    }
    
    subscript(key: String) -> String? {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if child.label == key {
                return child.value as? String
            }
        }
        return nil
    }
}
