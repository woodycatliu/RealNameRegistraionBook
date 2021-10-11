//
//  RemoteURLFileHandle.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/9/5.
//

import Foundation

/*
 支持存取遠端 url 加載的Data
 - name: 資料夾名稱
 - pathExtension: 存取檔案類型。
 - 每次重新加載該類，會將與 name 相同資料夾清空
 */
class RemoteUrlFileHandle {
    
    enum FileHandle: Error {
        case baseUrlIsMiss
    }
    
    private let file: FileManager = .default
    
    private var baseUrl: URL?
    
    let folderName: String
    
    let pathExtension: String?
    
    init(name: String = "PlayRecord", pathExtension: String? = nil) {
        self.pathExtension = pathExtension
        folderName = name
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
           let folder = createFolder(name: name, url: docDir) {
            baseUrl = folder
        }
    }
    
    /// 嘗試將 data 寫入
    /// url : 原始 url
    /// return 存入的 filePath
    func write(data: Data, url: URL) throws -> URL {
        
        guard let baseUrl = baseUrl else {  throw  FileHandle.baseUrlIsMiss }
        
        let lastPathComponent = url.lastPathComponent
        var newUrl = baseUrl.appendingPathComponent(lastPathComponent)
        
        if let pathExtension = pathExtension {
            newUrl.appendPathExtension(pathExtension)
        }
        
        do {
            try data.write(to: newUrl)
            return newUrl
        }
        catch {
            Logger.log(message: error)
            throw error
        }
    }
    
    
    /// 創建資料夾
    /// - Parameters:
    ///   - name: 資料夾名稱
    ///   - url: file path
    ///   - 呼叫此 func 會隱性把已存在的資料夾清空
    /// - Returns: 資料夾 path
    func createFolder(name: String, url: URL)-> URL? {
        let folder = url.appendingPathComponent(name, isDirectory: true)
        let exist = file.fileExists(atPath: folder.path)
        
        // 如果存在，則先移除所有暫存檔案
        // 再重新創建
        if exist {
            // 嘗試移除所有資料
            // 失敗不處理
            try? file.removeItem(at: folder)
        }
        
        do {
            try file.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
            return folder
        }
        catch {
            Logger.log(message: error)
            return nil
        }
    }
    
    func dataExist(url: URL)-> Bool {
        return file.fileExists(atPath: url.path)
    }
    
}

// MARK: Logic
extension RemoteUrlFileHandle {
    
    /// 將URL 換成 filePathUrl
    func transformURL(urlString: String)-> URL? {
        
        guard let url = URL(string: urlString),
              var baseUrl = baseUrl else { return URL(string: urlString) }
        
        let lastPathComponent = url.lastPathComponent
        
        baseUrl.appendPathComponent(lastPathComponent)
        
        if let pathExtension = pathExtension {
            baseUrl.appendPathExtension(pathExtension)
        }
        
        return baseUrl
    }
    
}
