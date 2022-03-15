//
//  WatchlistViewModel.swift
//  EmefarTMDbDemo
//
//  Created by Mervan Şahinkaya on 15.03.2022.
//  Copyright © 2022 Mervan Şahinkaya. All rights reserved.
//

import UIKit

protocol WatchlistViewModelProtocol {
    var movieDidChanges: ((Bool, Bool) -> Void)? { get set }
    func getWatchlist()
    func removeIndex(index: Int)
}

class WatchlistViewModel: WatchlistViewModelProtocol {
    
    var movieDidChanges: ((Bool, Bool) -> Void)?
    
    var movies: [Movie] = [] {
        didSet {
            self.movieDidChanges!(true, false) // Send feedback when data received & deleted
        }
    }
    
    func getWatchlist() {
        
        do {
            let preferencesDirectoryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("Preferences", isDirectory: true)
            let fileURL = preferencesDirectoryURL.appendingPathComponent("watchlist.json")
            
            if let data = try? Data(contentsOf: fileURL) {
                let decoded = try JSONDecoder().decode([Movie].self, from: data)
                self.movies = decoded
            }else{
                self.movies = []
 
            }
        } catch { print("err31: ", error) }
        
    }
    
    func removeIndex(index: Int){
        
        
        do {
            let preferencesDirectoryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("Preferences", isDirectory: true)
            let fileURL = preferencesDirectoryURL.appendingPathComponent("watchlist.json")
            
            if let data = try? Data(contentsOf: fileURL) {
                var decoded = try JSONDecoder().decode([Movie].self, from: data)
                                
                for (forIndex, element) in decoded.enumerated() {
                 
                    if element.id == movies[index].id {
                        
                        decoded.remove(at: forIndex)
                        
                        
                        do {
                            let encoded = try JSONEncoder().encode(decoded)
                            let preferencesDirectoryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("Preferences", isDirectory: true)
                            let fileURL = preferencesDirectoryURL.appendingPathComponent("watchlist.json")
                            try encoded.write(to: fileURL)
                            
                            self.movies.remove(at: index)

                        } catch { print("err192: ", error) }
                        

                        return
                    }
                    
                }
     
                
            }
        } catch { print("err63: ", error) }
        

    }
    
}
