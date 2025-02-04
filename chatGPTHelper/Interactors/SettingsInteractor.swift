import Foundation
import SwiftData

protocol SettingsInteractorProtocol: Interactor {
    func fetchText()
    func saveText()
    func getFiles() -> [String]
    func didChangeSourceFile()
}

final class SettingsInteractor: Interactor, SettingsInteractorProtocol {
    
    func getFiles() -> [String] {
        guard let textsPath = Bundle.main.resourcePath else { return [] }
        
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: textsPath)
            return fileNames.map { ($0 as NSString).deletingPathExtension }
        } catch {
            print("Error reading contents of Texts folder: \(error)")
            return []
        }
    }
    
    @MainActor
    func didChangeSourceFile() {
        guard let appStateModel else { return }
        
        appStateModel.clearCaches()
        localRepository.save(SettingData(textFileName: appStateModel.textFileName))
    }
    
    func fetchText() {
    }
    
    func saveText() {
    }
    
    
    // private var mockedResponseData: [MockedResponseData]    

    // func fetchText() {
    //     if let data = mockedResponseData.first {
    //         appStateModel?.mockText = data.text
    //     }
    //     print(appStateModel?.mockText ?? "")
    // }

    // func saveText() {
    //     if let existingData = mockedResponseData.first {
    //         existingData.text = appStateModel?.mockText ?? ""
    //         existingData.isEnabled = appStateModel?.isMockEnabled ?? false
    //     } else {
    //         let newData = MockedResponseData(text: appStateModel?.mockText ?? "", isEnabled: appStateModel?.isMockEnabled ?? false)
    //         localRepository.save(newData)
    //     }

    //     do {
    //         try localRepository.modelContext?.save()
    //         print("Note saved successfully.")
    //     } catch {
    //         print("Failed to save note: \(error.localizedDescription)")
    //     }
    // }
}
