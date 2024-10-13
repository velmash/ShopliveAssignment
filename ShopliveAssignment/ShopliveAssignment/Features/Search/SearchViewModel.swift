//
//  SearchViewModel.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/13/24.
//

import Foundation

class SearchViewModel {
    private var searchTask: DispatchWorkItem?
    
    func searchCharacters(nameStartsWith: String, completion: @escaping ([Character]) -> Void) {
        // 이전 검색 작업 취소
        searchTask?.cancel()
        MarvelAPI.shared.cancelCurrentSearch()
        
        // 새로운 검색 작업 생성
        let task = DispatchWorkItem { [weak self] in
            MarvelAPI.shared.searchCharacters(nameStartsWith: nameStartsWith) { result in
                switch result {
                case .success(let characters):
                    DispatchQueue.main.async {
                        completion(characters)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            }
        }
        
        // 검색 작업 저장
        searchTask = task
        
        // 0.3초 후에 검색 작업 실행
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }
}
