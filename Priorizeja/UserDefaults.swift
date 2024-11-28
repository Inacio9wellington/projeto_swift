import Foundation
extension UserDefaults {
    private static let lembretesKey = "LembretesKey"

    func saveLembretes(_ lembretes: [Lembrete]) {
        if let encoded = try? JSONEncoder().encode(lembretes) {
            self.set(encoded, forKey: UserDefaults.lembretesKey)
        }
    }

    func loadLembretes() -> [Lembrete] {
        if let data = self.data(forKey: UserDefaults.lembretesKey),
           let decoded = try? JSONDecoder().decode([Lembrete].self, from: data) {
            return decoded
        }
        return []
    }
}

