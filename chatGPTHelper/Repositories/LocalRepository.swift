//
//  LocalRepository.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 19.12.2024.
//

import Foundation
import SwiftData

final class LocalRepository {
    var modelContext: ModelContext?

//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//    }

    func fetchSummaries() -> [SummaryData]? {
        let fetchRequest = FetchDescriptor<SummaryData>()
        do {
            let result = try modelContext?.fetch(fetchRequest)
            return result
            
        } catch {
            print("Failed to fetch summaries: \(error)")
            return nil
        }
    }
    
    func deleteAllSummaries() {
        do {
            try modelContext?.delete(model: SummaryData.self)
        } catch {
            print("Failed to delete students.")
        }
    }
    
    func save(_ summaryObject: SummaryData) {
        guard let modelContext else {
            assertionFailure("No context for saving data")
            return
        }
                
        modelContext.insert(summaryObject)
        do {
            print("save")
            try modelContext.save()
        } catch {
            print("there was an error")
            //TODO
        }
    }
    
}
