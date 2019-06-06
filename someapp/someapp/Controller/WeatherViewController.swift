//
//  WeatherViewController.swift
//  someapp
//
//  Created by Mikita Ishchanka on 6/5/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import CoreLocation
import CoreImage
import CoreText
class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    static let apiKey = "0f2c5ce9-237c-438a-8b83-22ac1abd0e96"
    var currentLatitude = "0.0"
    var currentLongitude = "0.0"
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        getWeather()
        // Do any additional setup after loading the view.
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first
        {
            currentLatitude = String(location.coordinate.latitude)
            print(location.coordinate)
            currentLongitude = String(location.coordinate.longitude)
        }
    }
    func getWeather() {
        var request = URLRequest(url: URL(string: "https://api.weather.yandex.ru/v1/forecast?lat=" +
            String(currentLatitude) + "&lon=" + String(currentLongitude) + "&lang=ru_Ru")!)
        request.setValue(WeatherViewController.apiKey, forHTTPHeaderField: "X-Yandex-API-Key")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                let fact = json["fact"] as! [String: Any]
                print(fact)
                let tempreture = fact["temp"] as! Double
                let feels_like = fact["feels_like"] as! Double
                let condition = fact["condition"] as! String
                self.tempLabel.text = String(tempreture)
                self.feelsLabel.text = String(feels_like)
                
                switch condition
                {
                case "clear":
                    do {
                    self.conditionLabel.text="Clear"
                    self.weatherImage.image = UIImage(named: "Clear")!
                }
                case "partly-cloudy":
                    do {
                        self.conditionLabel.text="Partly cloudy"
                        self.weatherImage.image = UIImage(named: "Partly cloudy")!
                    }
                case "cloudy":
                    do {
                        self.conditionLabel.text="Cloudy"
                        self.weatherImage.image = UIImage(named: "Cloudy")!
                    }
                case "overcast":
                    do {
                        self.conditionLabel.text="Overcast"
                        self.weatherImage.image = UIImage(named: "Overcast")!
                    }
                case "partly-cloudy-and-light-rain","cloudy-and-light-rain", "overcast-and-light-rain":
                    do {
                        self.conditionLabel.text="Light rain"
                        self.weatherImage.image = UIImage(named: "Light rain")!
                    }
                case "partly-cloudy-and-rain", "cloudy-and-rain":
                    do {
                        self.conditionLabel.text="Rain"
                        self.weatherImage.image = UIImage(named: "Rain")!
                    }
                case "overcast-and-rain":
                    do {
                        self.conditionLabel.text="Heavy rain"
                        self.weatherImage.image = UIImage(named: "Heavy rain")!
                    }
                case "overcast-thunderstorms-with-rain":
                    do {
                        self.conditionLabel.text="Heavy rain, thunderstorm"
                        self.weatherImage.image = UIImage(named: "Heavy rain, thunderstorm")!
                    }
                case "overcast-and-wet-snow":
                    do {
                        self.conditionLabel.text="Sleet"
                        self.weatherImage.image = UIImage(named: "Sleet")!
                    }
                case "partly-cloudy-and-light-snow", "cloudy-and-light-snow", "overcast-and-light-snow":
                    do {
                        self.conditionLabel.text="Light snow"
                        self.weatherImage.image = UIImage(named: "Light snow")!
                    }
                case "partly-cloudy-and-snow", "cloudy-and-snow":
                    do {
                        self.conditionLabel.text="Snow"
                        self.weatherImage.image = UIImage(named: "Snow")!
                    }
                case "overcast-and-snow":
                    do {
                        self.conditionLabel.text="Snowfall"
                        self.weatherImage.image = UIImage(named: "Snowfall")!
                    }
                default:
                    self.conditionLabel.text="Clear"
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

