/*
 * Copyright 2020 Rohit Kumar Singh,
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * @author Rohit Kumar Singh rsingh92@asu.edu
 *
 * @version March 2016
 */


import Foundation
import UIKit

class PlaceLibrary{
    
//    static var allPlaces = Array<PlaceDescription>()
    
    static var allremotePlaces = Array<PlaceDescription>()
    
    private static var urlString:String = "http://127.0.0.1:8080"
    
    
    private static var listSize: Int = 0
    private static var placeParced: Int = 0

    
//    static func createDummyPlaceList() -> Array<PlaceDescription> {
//
//        var places = Array<PlaceDescription>()
//
//        for i in 1...10 {
//            let place = PlaceDescription(placeName: "Place "+i.description)
//            place.placeDescription = "Desc "+i.description
//            place.category = "Category "+i.description
//            place.streetAddress = "StreetAddress "+i.description
//            place.streetTitle = "Street Title "+i.description
//            place.elevation = Double(10+i);
//            place.latitude = Double(233+i)
//            place.longitude = Double(100+i)
//            places.append(place)
//        }
//
//        return places
//    }
    
    static func loadAllPlacesFromMemory(vc: UIViewController){
        getAllPlacesFromServer(vc: vc)
    }
    
    
    static func getAllPlaces() -> Array<PlaceDescription>{
        return allremotePlaces
    }
    
    private static func loadPlaceinPlaceList(placeName: String, vc: UIViewController){
        let connection: PlaceCollectionAsyncTask = PlaceCollectionAsyncTask(urlString: urlString)
        connection.get(name: placeName, callback: {(res: String, err: String?) -> Void in
            
            if err != nil{
                NSLog(err!)
            }else{
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    
                    
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options : []) as? [String: Any]{
                            
                            
                            let placeDetail = jsonObject["result"] as? [String:Any]
                            
                            
                            
                            allremotePlaces.append(getPlaceDescFromJson(jsonObject: placeDetail ?? ["":nil]))
                            
                        } else {
                            print("bad json")
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
            
            
            
            placeParced = placeParced+1
            
            if(placeParced==listSize){
                let placeListVC = vc as! PlaceListViewController
                placeListVC.refreshList()
            }
            
            
        })
    }
    
    static func getAllPlacesFromServer(vc : UIViewController){
        
        let connection: PlaceCollectionAsyncTask = PlaceCollectionAsyncTask(urlString: urlString)
        
        connection.getNames(callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    
//                    print(data.description)
                    
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options : []) as? [String: Any]{
                            
                            let placelist = vc as! PlaceListViewController
                            let placeNamesArray = jsonObject["result"] as! [String]
                            
                            listSize = placeNamesArray.count
                            
                            for placeName in placeNamesArray{
                                
                                
                                
                                loadPlaceinPlaceList(placeName: placeName, vc: vc)
                                
                                
                            }
                            
                            
                        } else {
                            print("bad json")
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
        })
    }
    
    private static func getPlaceDescFromJson(jsonObject: [String:Any]) -> PlaceDescription{
        
        let place = PlaceDescription()
        
        print(place==nil)
        
        place.placeName = jsonObject["name"] as? String
        place.placeDescription = jsonObject["description"] as? String
        place.category = jsonObject["category"] as? String
        place.streetTitle = jsonObject["address-title"] as? String
        place.streetAddress = jsonObject["address-street"] as? String
        place.latitude = jsonObject["latitude"] as? Double
        place.longitude = jsonObject["longitude"] as? Double
        place.elevation = jsonObject["elevation"] as? Double
        
        
//        print(place.placeName!)
//        print(place.placeDescription!)
//        print(place.category!)
//        print(place.streetAddress!)
//        print(place.streetTitle!)
//        print(place.elevation!)
//        print(place.longitude!)
//        print(place.latitude!)
        
        
        

        return place
    }
    
    
}
