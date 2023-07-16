//
//  LevenshteinDistance.swift
//  chapter-24_StringMatching
//
//  Created by 丰源天下传媒 on 2023/5/3.
//

import Foundation

// 打印二维数组
func printMatrix(matrix: Array<Array<Int>>) {
    matrix.forEach {
        $0.forEach { item in
            print( "\(item)  ", separator: "", terminator:"")
        }
        print("\n")
    }
}

// 最小的数字
func min(numbers: Int...) -> Int {
    return numbers.reduce(numbers[0], {$0 < $1 ? $0 : $1})
}

func levenshteinDistance(strA: String, strB: String) -> Int {
    // 创建字符数组
    let a = Array(strA)
    let b = Array(strB)
 
    // 初始化结果矩阵，Size（|a|+1  ， |b|+1） 。 全部用0进行初始化。
    var matrix = Array<Array<Int>>()
    for _ in 0...a.count {
        var rowData = Array<Int>(repeating: 0, count: b.count + 1)
        matrix.append(rowData)
    }
    print("-A-----------------------------")
    printMatrix(matrix: matrix)
    // A 前缀可以通过删除每个字符转换为空字符串
    for i in 1...a.count {
        matrix[i][0] = i
    }
    print("-B-----------------------------")
    printMatrix(matrix: matrix)
    
    // 通过插入每个字符，可以从空字符串创建“字符串B”前缀
    for j in 1...b.count {
        matrix[0][j] = j
    }
    print("-C----------------------------")
    printMatrix(matrix: matrix)
    
    for i in 1...a.count {
        for j in 1...b.count {
            if a[i-1] == b[j-1] {
                matrix[i][j] = matrix[i-1][j-1]  // 结尾都去掉，编辑距离相等
            } else {
                matrix[i][j] = min(
                    matrix[i-1][j] + 1,   // 删除
                    matrix[i][j-1] + 1,   // 插入
                    matrix[i-1][j-1] + 1  // 替换
                )
            }
        }
    }
    return matrix[a.count][b.count]
}

levenshteinDistance(strA: "rick", strB: "rcik")
levenshteinDistance(strA: "rick", strB: "irkc")
levenshteinDistance(strA: "rcik", strB: "irkc")
