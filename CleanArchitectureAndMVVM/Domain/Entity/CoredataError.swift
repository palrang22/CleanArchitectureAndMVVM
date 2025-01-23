//
//  CoredataError.swift
//  CleanArchitectureAndMVVM
//
//  Created by 김승희 on 1/23/25.
//

import Foundation

public enum CoredataError: Error {
    case entityNotFound(String) // 조회하는 엔티티를 찾을 수 없을 때
    case saveError(String)
    case readError(String)
    case deleteError(String)
    
    public var description: String {
        switch self {
        case .entityNotFound(let message):
            "객체를 찾을 수 없습니다: \(message)"
        case .saveError(let message):
            "객체 저장 에러: \(message)"
        case .readError(let message):
            "객체 조회 에러: \(message)"
        case .deleteError(let message):
            "객체 삭제 에러: \(message)"
        }
    }
}
