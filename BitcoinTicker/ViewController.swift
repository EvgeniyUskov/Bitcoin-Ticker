//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate   {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySigns = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
    // how many columns pikcer has
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // how many items(rows) picker has
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    // fill picker with items
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    // select row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        let pickedItem = currencyArray[row]
        let finalURL = constructURL(url: baseURL, currency: pickedItem)

        getRate(url: finalURL, currencySignIndex: row)
    }
    
    func constructURL (url: String, currency: String) -> String {
        return url+currency
    }

//    //MARK: - Networking
//    /***************************************************************/
//
    func getRate(url: String, currencySignIndex: Int) {
        //make a request
        Alamofire.request(url, method: .get)
            //response JSON
            .responseJSON {
                response in
                    if response.result.isSuccess {
                        print("getRate() Success")
                        print("Response: \(response)")
                        let JSONResponse: JSON = JSON(response.result.value!)
                        self.bitcoinPriceLabel.text = "\(self.currencySigns[currencySignIndex])\(self.parsePrice(response: JSONResponse))"
                    }
                    else {
                        print("getRate() Error")
                        self.bitcoinPriceLabel.text = "Connection issue"
                    }
        }
        
    }
    
    //    //MARK: - JSON Parsing
    //    /***************************************************************/
    //
    func parsePrice(response: JSON) -> String {
        return response["ask"].stringValue
    }
    //    func updateWeatherData(json : JSON) {
//        
//        if let tempResult = json["main"]["temp"].double {
//        
//        weatherData.temperature = Int(round(tempResult!) - 273.15)
//        weatherData.city = json["name"].stringValue
//        weatherData.condition = json["weather"][0]["id"].intValue
//        weatherData.weatherIconName =    weatherData.updateWeatherIcon(condition: weatherData.condition)
//        }
//        
//        updateUIWithWeatherData()
//    }
//    




}

