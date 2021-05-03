import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
    let height: String
    let birth_year: String
    let homeworld: URL
    
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
    let characters: [URL]
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        //Step 1: Prepare URL
        guard let baseURL = baseURL else {return completion(nil)}
        let peopleURL = baseURL.appendingPathComponent("people")
        let finalURL = peopleURL.appendingPathComponent(String(id))
        //Step 2: Contact Server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            //Step 3: Handle errors
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            //Step 4: Check for Data
            guard let data = data else {return completion(nil)}
            
            //Step 5: Decode Person from JSON
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        //Step 1: Contact Server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            //Step 2: Handle Errors
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
            //Step 3: Check For Data
            guard let data = data else {return completion(nil)}
            
            //Step 4: Decode File From JSON
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
}//End of class


SwapiService.fetchPerson (id: 44) { person in
    if let person = person {
        print(person.name)
        for item in person.films {
            SwapiService.fetchFilm(url: item) { (film) in
                if let film = film {
                    print(film.title)
                    print(film.opening_crawl)
                    print("")
                }
            }
        }
    }
}
