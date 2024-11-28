//
//  Lembrete.swift
//  Dicas_alimentacao
//
//  Created by user on 28/11/24.
//

import Foundation

struct Lembrete: Identifiable, Codable, Equatable {
    let id: UUID
    let titulo: String
    let descricao: String
    let horario: Date
    let data: Date

    // Implementação automática de Equatable
    static func == (lhs: Lembrete, rhs: Lembrete) -> Bool {
        return lhs.id == rhs.id
    }
}

