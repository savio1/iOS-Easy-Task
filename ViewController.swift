//
//  ViewController.swift
//  WeatherApp_Bare
//
//  Created by Savio Neyyan on 2017-08-20.
//  Copyright © 2017 Savio Neyyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct myVariable{
        static var temp = "var1"
    }

    @IBOutlet weak var label: UILabel!
    
    
    private let openWeatherMapBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "f08146623d90812ccb678e677d5463ee"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        label.hidden = true;
        
        getWeather("Houston");

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Button(sender: AnyObject) {
        label.hidden = false
    }
    func getWeather(city: String){
        // Using shared sessions to retrieve data
        let session = NSURLSession.sharedSession()
        
        //Input request parameters
        let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
        
        // The data task retrieves the data.
        let dataTask = session.dataTaskWithURL(weatherRequestURL) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let error = error {
                //This is the case where an error occurs
                print("Error:\n\(error)")
                self.label.text="Error";
            }
            else {
                
                //This is the case when we get a response from the server
                print("Raw data\n\(data!)\n")
                let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
                print("Readable data:\n\(dataString!)")
                
                //Creating substring, did not use json format, so string is clumped data. OWM has rigid data format, so it's easy to always find correct value.
                let strArr = dataString?.componentsSeparatedByString(":");
                
                //Temperature is located at index 10 substring
                let values: String = (strArr![11])
                
                //Remove 'pressure' from substring
                let temptemp = values.componentsSeparatedByString(",");
                
                //Temperature adjustments
                let temp1: String = (temptemp[0])
                let convert = Double(temp1)!-273.15;
                let temp2 = String(convert);
                let degree="65\u{00B0}C" //degree symbol
                let temp=temp2+degree;
                print("\n")
                print(values)
                print(temp1)
                print(temp)
                
                //Changing labels.
                dispatch_async(dispatch_get_main_queue()) {
                    // update label
                    self.label.text = temp
                }
                
            }
        }
        //Resuming the data task
        dataTask.resume()
    }
    
}

