
import Foundation
import CoreLocation


protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    
}


struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=4c0de742453d0d35ac165d7715aa990e&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func featchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        // print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        // print(urlString)
        performRequest(with: urlString)
        
        
    }
    
    
    func performRequest(with urlString: String){
        //1. create URL
        if let url = URL(string: urlString){
            //2. create a urlSession
            let session = URLSession(configuration: .default)
            //3. Give a session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(safeData)
                    {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    //                                   let dataString = String(data: safeData, encoding: .utf8)
                    //                                        print(dataString)
                    
                    
                }
            }
            //4. Start the task
            task.resume()
            
            
        }
        
    }
    
    func parseJSON (_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            
            let decodedData  =    try decoder.decode(WeatherData.self, from: weatherData)
            // print(decodedData.weather[0].description)  to print weather condition
            
            let id = decodedData.weather[0].id            //  print(id)
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp) // wather object created from weather model
            
            //   print (weather.conditionName)
            
            
            return weather
            
            
            
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil //we don't have a weather object to return
        }
        
    }
    
    
    
    
    
}
