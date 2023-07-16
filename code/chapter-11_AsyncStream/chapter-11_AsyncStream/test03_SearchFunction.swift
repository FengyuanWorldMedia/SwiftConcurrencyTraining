//
//  test03_SearchFunction.swift
//  chapter-11_AsyncStream
//
//  Created by 丰源天下传媒 on 2023/3/12.
//

import Foundation

enum SearchError: Int, Error {
    case network = 400
}

enum Status {
    case printing(String)
    case finished(String)
}

struct SearchCompany {
    func searchCompanyInfo(_ url: URL, progressHandler:@escaping (String) -> Void, completion: @escaping (Result<String, Error>) -> Void) throws {
        Task {
            do {
                for try await line in url.lines {
                    progressHandler(line)
                }
                completion(Result.success("查询完成"))
            } catch(let e) {
                print(e.localizedDescription)
                completion(Result.failure(SearchError.network))
            }
        }
    }
    
}

extension SearchCompany {
    func search(_ url: URL) -> AsyncThrowingStream<Status, Error> {
        return AsyncThrowingStream { continuation in
            do {
                try self.searchCompanyInfo(url, progressHandler: { progress in
                    continuation.yield(.printing(progress))
                }, completion: { result in
                    switch result {
                    case .success(let data):
                        continuation.yield(.finished(data))
                        continuation.finish()
                    case .failure(let error):
                        continuation.finish(throwing: error)
                    }
                })
            } catch {
                continuation.finish(throwing: error)
            }
        }
    }
}


func test03_SearchCompany() {
    let searchCompany = SearchCompany()
    let url = URL(string: "http://www.baidu.com/s?wd=fengyuantianxa")!
    Task {
        do {
            for try await status in searchCompany.search(url) {
                switch status {
                    case .printing(let progress):
                        print("查询中: \(progress)")
                    case .finished(let data):
                        print("查询结束: \(data)")
                }
            }
            print("AsyncThrowingStream 由 finished() 关闭")
        } catch {
            print("AsyncThrowingStream 由 finish(throwing: error) 关闭")
            print("异常信息: \(error)")
        }
    }
}
