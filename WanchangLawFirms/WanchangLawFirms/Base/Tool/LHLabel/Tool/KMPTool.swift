//
//  KMPTool.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/18.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class KMPTool: NSObject {
    static let share = KMPTool()
    
    func kmp(str: String, ptn: String) -> Int {
        let m = str.count
        let n = ptn.count
        var next: [Int] = Array<Int>(repeating: 0, count: n)
        kmp_next(ptn: ptn, next: &next)
        var i = 0
        var j = 0
        var loop = 0
        while i < m && j < n {
            loop += 1
            if str.sub_string(at: i) == ptn.sub_string(at: j) {
                i += 1
                j += 1
            } else if j == 0 {
                i += 1
            } else {
                j = next[j]
            }
        }
        if j >= n {
            return i - n
        }
        return -1
    }
    
    private func kmp_next(ptn: String, next: inout [Int]) {
        let n = ptn.count
        var i = 1
        var j = 0
        if n >= 1 {
            next[0] = 0
        }
        while i < n {
            if ptn.sub_string(at: i) == ptn.sub_string(at: j) {
                i += 1
                j += 1
                if i < n {
                    if ptn.sub_string(at: i) == ptn.sub_string(at: j) {
                        next[i] = j
                    } else {
                        next[i] = next[j]
                    }
                }
            } else if j == 0 {
                next[i] = j
                i += 1
            } else {
                j = next[j]
            }
        }
    }

}

extension String {
    func sub_string(at: Int) -> String {
        let ns = self as NSString
        return ns.substring(with: NSRange.init(location: at, length: 1))
    }
}
