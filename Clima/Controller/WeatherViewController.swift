
import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager() // its responsible for hold current gps location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self // this line code write befor requestlocation otherwise app crash.
        
        locationManager.requestWhenInUseAuthorization()  // to take permission
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate =  self
        
    }
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}
// MARK: - UITextFieldDelegate

extension WeatherViewController:UITextViewDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        
        // print(searchTextField.text! ?? "error")
        print(searchTextField.text!)
        
        if searchTextField.text != ""{
            
            searchTextField.placeholder = "Enter city Name!"
        }
        else{
            searchTextField.placeholder = "Type Something!!"
        }
        searchTextField.endEditing(true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            weatherManager.featchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }
        else{
            textField.placeholder = "Type Something"
            return false
        }
    }
}


// MARK: - WeatherManagerDelegate
// creat extension
extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        // print(weather.temperature)
        DispatchQueue.main.async {
            self.temperatureLabel.text=weather.temperatureString
            self.conditionImageView.image = UIImage (systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self
        }
    }
    
    func didFailWithError(error: Error)
    {
        print(error)
    }
}

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon =  location.coordinate.longitude
            // weatherManager.featchWeather(latitude: lat, longitude: lon)
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

