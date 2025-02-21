//
//  Interactor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 16.12.2024.
//

import Foundation
import SwiftUI
import SwiftData

protocol SummaryInteractorProtocol: Interactor {
    
    func requestAllSummaries() async
    
    func onAppear()
    
    func getEmbedding(for chapterNumber: Int) async
}

final class SummaryInteractor: Interactor, SummaryInteractorProtocol {
    
    @MainActor
    func getEmbedding(for chapterNumber: Int) async {
        guard let chapterText = appStateModel?.chapters[chapterNumber] else { return }
        
        print(chapterText.components(separatedBy: .newlines))
        
        return
        
        do {
            let embedding = try await webRepository.fetchChatGPTEmbeddings(prompt: chapterText)
            if let summaryData = appStateModel?.summaries.filter({ $0.chapterNumber == chapterNumber}).first {
                summaryData.embedding = embedding
                print(embedding)
                Task(priority: .background) {
                    self.localRepository.save(summaryData)
                }
            }
            
        } catch {
            print("Failed to get an embedding a chapter: \(error)")
        }
    }
    
    @MainActor
    func requestAllSummaries() async  {
        removeOldSummaries()
        setupText()
        guard let chapters = appStateModel?.chapters else { return }
        
        for (index, chapter) in chapters.enumerated().prefix(2) {
            guard let promptInitialText = self.appStateModel?.prompts[.summary]?.value else { return }
            
            do {
                let response = try await webRepository.fetchChatGPTResponse(prompt: promptInitialText + chapter)
                let summaryObject = SummaryData(chapterNumber: index, text: response, textFileName: self.appStateModel?.textFileName ?? "")
                self.appStateModel?.summaries.append(summaryObject)
                Task(priority: .background) {
                    self.localRepository.save(summaryObject)
                }
            } catch {
                print("Failed to fetch summary for a chapter: \(error)")
            }
        }        
    }
    
    @MainActor
    func onAppear() {
        guard let appStateModel,
              !appStateModel.isSummaryLocalCacheValid else { return }
        
        let fileName = appStateModel.textFileName
        let predicate = #Predicate<SummaryData> {
            $0.textFileName == fileName
        }
        guard let result: [SummaryData] = localRepository.fetch(withPredicate: predicate) else { return }
        
        DispatchQueue.main.async {
            self.setupText()
        }
        
        appStateModel.isSummaryLocalCacheValid = true
        DispatchQueue.main.async {
            self.appStateModel?.summaries = result
        }
    }
    
    private func removeOldSummaries() {
        DispatchQueue.main.async {
//            self.localRepository.deleteAllSummaries()
            self.appStateModel?.summaries = []
        }
    }
    
    @MainActor
    private func allEmbeddings() -> [[Double]]? {
        return appStateModel?.summaries.compactMap { $0.embedding }
    }
    
//    func searchNovel(for query: String, completion: @escaping ([TextChunk]) -> Void) async {
//        
//        do {
//            let embedding = try await webRepository.fetchChatGPTEmbeddings(prompt: query)
//            
//            let sortedChunks = allEmbeddings()?.compactMap { chunk -> (String, Double)? in
//                guard let chunkEmbedding = chunk.embedding else { return nil }
//                let similarity = cosineSimilarity(chunkEmbedding, queryEmbedding)
//                return (chunk, similarity)
//            }
//            .sorted { $0.1 > $1.1 }  // Sort by highest similarity
//            
//            completion(sortedChunks.prefix(3).map { $0.0 }) // Return top 3 results
//            
//        } catch {
//            //
//        }
//       
//    }
    
    private func cosineSimilarity(_ vectorA: [Double], _ vectorB: [Double]) -> Double {
        guard vectorA.count == vectorB.count else { return 0.0 }
        
        let dotProduct = zip(vectorA, vectorB).map(*).reduce(0, +)
        let magnitudeA = sqrt(vectorA.map { $0 * $0 }.reduce(0, +))
        let magnitudeB = sqrt(vectorB.map { $0 * $0 }.reduce(0, +))
        
        return magnitudeA > 0 && magnitudeB > 0 ? dotProduct / (magnitudeA * magnitudeB) : 0.0
    }
}
