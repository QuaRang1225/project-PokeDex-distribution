//
//  VarietiesApiService.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/17/24.
//

import ComposableArchitecture
import Foundation

/// 다른 모습 APIClient
struct VarietiesClient {
    typealias ReturnVarieties = @Sendable (_ name:String) async throws -> VarietiesRespons
    
    /// 다른 모습 요청
    var fetchVariety: ReturnVarieties
}

// MARK: - 각 요청에 해당하는 의존성 키 주입
extension VarietiesClient: DependencyKey {
    static var liveValue: VarietiesClient {
        let variety: ReturnVarieties = { name in
            let request = VarietiesRouter.variety(name: name).makeURLRequest()
            return try await URLSession.shared.requestDecoding(VarietiesRespons.self, urlRequest: request)
        }
        return VarietiesClient(fetchVariety: variety)
    }
}

// MARK: - 외부에서 접근하기 위해 의존성 값 반환
extension DependencyValues {
    var varietiesClient: VarietiesClient {
        get {
            self[VarietiesClient.self]
        } set {
            self[VarietiesClient.self] = newValue
        }
    }
}
