//
//  LocalFileManager.swift
//  SwiftfulCrypto
//
//  Created by Outsider on 2025/4/9.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    private init() {
        
    }
    
    func savaImage(image:UIImage, imageName:String, folderName:String){
        
        //创建文件夹
        createFolderIfNeed(folderName: folderName)
        
        //获取图像路径
        guard let data = image.pngData(),
              let url = getURLForImage(imageNane: imageName, folderName: folderName)
        else{return}
        
       //保存图像到此路径
        do {
            try data.write(to: url)
        } catch let error {
            print("无法保存图片,图片名字:\(imageName).\(error)")
        }
        
    }
    // 从指定文件夹中获取指定名称的图片
    func getImage(imageName:String, folderName:String) -> UIImage? {
        guard let url = getURLForImage(imageNane: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
    
    //创建文件夹
    private func createFolderIfNeed(folderName:String){
        guard let url = getURLForFolder(folderName: folderName) else {return}
        if !FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("创建目录失败,文件夹名字:\(folderName).\(error)")
            }
        }
    }
    
    //获取URL到文件夹
    private func getURLForFolder(folderName:String) -> URL?{
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else{ return nil }
        return url.appendingPathComponent(folderName)
    }
    
    //获取图片到文件夹
    private func getURLForImage(imageNane:String, folderName:String) -> URL?{
        guard let folderURL = getURLForFolder(folderName: folderName) else{ return nil }
        return folderURL.appendingPathComponent(imageNane + ".png")
    }
    
}
