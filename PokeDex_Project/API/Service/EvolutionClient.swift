//
//  EvolutionApiRouter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/20/24.
//

import Foundation
import ComposableArchitecture

/// 진화트리 APIClient
struct EvolutionClient {
    typealias ReturnEvolution = @Sendable (_ num: Int) async throws -> EvolutionTreeResponse
    
    /// 진화트리 요청
    var fetchEvolution: ReturnEvolution
}

// MARK: - 각 요청에 해당하는 의존성 키 주입
extension EvolutionClient: DependencyKey {
    static var liveValue: EvolutionClient {
        let evolution: ReturnEvolution = { num in
            let request = EvolutionRouter.evolutuon(num: num).makeURLRequest()
            return try await URLSession.shared.requestDecoding(EvolutionTreeResponse.self, urlRequest: request)
        }
        return EvolutionClient(fetchEvolution: evolution)
    }
}

// MARK: - 외부에서 접근하기 위해 의존성 값 반환
extension DependencyValues {
    var evolutionClient: EvolutionClient {
        get {
            self[EvolutionClient.self]
        } set {
            self[EvolutionClient.self] = newValue
        }
    }
}
