import Foundation
import SwiftData

protocol SettingsInteractorProtocol: Interactor {
    func fetchText()
    func saveText()
}

final class SettingsInteractor: Interactor, SettingsInteractorProtocol {
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
