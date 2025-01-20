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
    //         promptParamsModel?.mockText = data.text
    //     }
    //     print(promptParamsModel?.mockText ?? "")
    // }

    // func saveText() {
    //     if let existingData = mockedResponseData.first {
    //         existingData.text = promptParamsModel?.mockText ?? ""
    //         existingData.isEnabled = promptParamsModel?.isMockEnabled ?? false
    //     } else {
    //         let newData = MockedResponseData(text: promptParamsModel?.mockText ?? "", isEnabled: promptParamsModel?.isMockEnabled ?? false)
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
