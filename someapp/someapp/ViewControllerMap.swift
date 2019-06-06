//
//  ViewControllerMap.swift
//  someapp
//
//  Created by Maksim Dvoryakov on 05/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class ViewControllerMap: UIViewController {
    
    @IBOutlet weak var gMapViev: GMSMapView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var timer: Timer!
    var counter: Int!
    var rectangle = GMSPolyline()
    var startCor = CLLocationCoordinate2D()
    var curCor = CLLocationCoordinate2D()
    var locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    var flag = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.isHidden=false
        stopButton.isHidden=true
        durationLabel.text="0.0"
        distanceLabel.text="0.0"
        speedLabel.text="0.0"
        caloriesLabel.text="0.0"
        counter=0
        flag=false
        let camera = GMSCameraPosition.camera(withLatitude: 53.939550, longitude: 27.464190, zoom: 10)
        //mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        gMapViev.animate(to: camera)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
 
        /*locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }*/
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    
    
    @IBAction func startF(_ sender: Any) {
        flag=true
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        startButton.isHidden=true
        stopButton.isHidden=false
        
    }
    
    @objc func timerUpdate() {
        counter+=1
        durationLabel.text = String(counter)
        
        var startLocation: CLLocationCoordinate2D = startCor
        var endLocation: CLLocationCoordinate2D = curCor
        print("start")
        print(startLocation)
        print("end")
        print(endLocation)
        let origin = "\(startLocation.latitude),\(startLocation.longitude)"
        let destination = "\(endLocation.latitude),\(endLocation.longitude)"
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking&key=AIzaSyDR9p8EzcY146HNpz3Y2LEfVCOBhuj8GoI"
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest){
            data, response, error in
            
            do {
                print("work with json")
                let  data = data
                    
                
                let json  = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                print(json)
                let arrayRoutes = json!["routes"] as! NSArray
                let arrLegs = (arrayRoutes[0] as! NSDictionary).object(forKey: "legs") as! NSArray
                let arrSteps = arrLegs[0] as! NSDictionary
                
                let dicDistance = arrSteps["distance"] as! NSDictionary
                let distance = dicDistance["text"] as! String
                self.distanceLabel.text=distance
                DispatchQueue.global(qos: .background).async {
                    let array = json!["routes"] as! NSArray
                    let dic = array[0] as! NSDictionary
                    let dic1 = dic["overview_polyline"] as! NSDictionary
                    let points = dic1["points"] as! String
                    print(points)
                    
                    DispatchQueue.main.async {
                       let path = GMSPath(fromEncodedPath: points)
                        self.rectangle.map = nil
                        self.rectangle = GMSPolyline(path: path)
                        self.rectangle.strokeWidth = 4
                        self.rectangle.strokeColor = UIColor.blue
                        self.rectangle.map = self.gMapViev
                        
                    }
                }
                
                //self.speedLabel.text=
            }
            catch{
                print("error")
            }
        }
        task.resume()
    }
    
    @IBAction func stopF(_ sender: Any) {
        timer.invalidate()
        durationLabel.text = "0.0"
        counter=0
        startButton.isHidden=false
        stopButton.isHidden=true
        
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

extension ViewControllerMap: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        print(userLocation)
        if(flag==true){
            startCor.latitude = (userLocation?.coordinate.latitude)!
            startCor.longitude = (userLocation?.coordinate.longitude)!
            flag=false
        }
        curCor.latitude = (userLocation?.coordinate.latitude)!
        curCor.longitude = (userLocation?.coordinate.longitude)!
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        gMapViev.animate(to: camera)
        mapView.isMyLocationEnabled = true
        
        locationManager.stopUpdatingLocation()
        /*let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
         print(locValue)*/
    }
}
