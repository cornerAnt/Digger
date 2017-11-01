//
//  DiggerThread.swift
//  Digger
//
//  Created by ant on 2017/10/27.
//  Copyright © 2017年 github.cornerant. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    static let barrier  = DispatchQueue(label: "com.github.cornerAnt.diggerThread.Barrier", attributes: .concurrent)
    static let cancel   = DispatchQueue(label: "com.github.cornerAnt.diggerThread.cancel",  attributes: .concurrent)
    static let download = DispatchQueue(label: "com.github.cornerAnt.downloadSession.download",attributes: .concurrent)
    static let forFun   = DispatchQueue(label: "com.github.cornerAnt.diggerThread.forFun",  attributes: .concurrent)
    
    func safeAsync(_ block: @escaping ()->()) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async { block() }
        }
    }
}
extension OperationQueue {
    
    static var downloadDelegateOperationQueue : OperationQueue {
        
        let downloadDelegateOperationQueue = OperationQueue()
        downloadDelegateOperationQueue.name = "com.github.cornerAnt.diggerThread.downloadDelegateOperationQueue"
        return downloadDelegateOperationQueue
        
    }
    
    
}

