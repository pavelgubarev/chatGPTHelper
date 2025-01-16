//
//  LocalRepository.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 19.12.2024.
//

import Foundation
import SwiftData

protocol LocalRepositoryProtocol {
    func fetch<T: PersistentModel>() -> [T]?
    
    func fetch<T: PersistentModel>(withID id: PersistentIdentifier) -> T? where T: Identifiable
    
    func deleteAllSummaries()
    
    func save<T: PersistentModel>(_ object: T)
    
    func downloadAndSaveImage(from url: String, completion: @escaping (String?) -> Void)
}

final class LocalRepository: LocalRepositoryProtocol {
    var modelContext: ModelContext?

    func fetch<T: PersistentModel>() -> [T]? {
        let fetchRequest = FetchDescriptor<T>()
        do {
            let result = try modelContext?.fetch(fetchRequest)
            return result
        } catch {
            print("Failed to fetch \(T.self): \(error)")
            return nil
        }
    }
    
    func fetch<T: PersistentModel>(withID id: PersistentIdentifier) -> T? where T: Identifiable {
        let result = modelContext?.model(for: id) as? T
        return result
    }
    
    func deleteAllSummaries() {
        do {
            try modelContext?.delete(model: SummaryData.self)
        } catch {
            print("Failed to delete")
        }
    }
    
    func save<T: PersistentModel>(_ object: T) {
        guard let modelContext else {
            assertionFailure("No context for saving data")
            return
        }
        
        modelContext.insert(object)
        do {
            print("Saving object: \(object)")
            try modelContext.save()
        } catch {
            print("Failed to save object: \(error)")
            // TODO: Handle error properly (e.g., error reporting or retry logic)
        }
    }    
    
    // TODO split
    func downloadAndSaveImage(from url: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("Invalid image data")
                completion(nil)
                return
            }

            do {
                let filename = UUID().uuidString + ".jpg"
                let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    .appendingPathComponent(filename)
                try data.write(to: fileURL)
                print("Image saved locally at: \(fileURL.path)")
                completion(fileURL.path)
            } catch {
                print("Failed to save image: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
