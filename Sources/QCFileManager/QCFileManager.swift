import Foundation

public struct QCFileManager {
    
    // init
    private init() {}
    public static let shared = QCFileManager()
    
    // private manager properties
    internal let fm = FileManager.default
    internal var DDURL:URL? {
        return fm.urls(for: .documentDirectory, in: .userDomainMask).first ?? nil
    }
    
    // public functions
    
    /// saveData(data:name:dataExtension:insideFolder:)
    /// This method helps in saving data type to document directry. You should give a nuique name to it that does't matches any previous data saved otherwise the data will not be saved. You can also save data by creating a folder, you just need to provide the name of the the folder.
    /// - Parameters:
    ///   - data: Data which you want to save in document directory
    ///   - name: name of this file ( must be unique )
    ///   - dataExtension: an optional field that provides extension to the file
    ///   - insideFolder: an optional filed that, if you want ot save the file inside a folder then specify that folders name if the folder is already present it will be saved there or a new folder will be created
    public func saveData(data:Data,name:String,dataExtension:String?=nil,insideFolder:String?=nil) {
        let fullName = "\(name)\(dataExtension ?? "")"
        if let fileURL = createUrlPath(directoryURL:getFolderURL(from: insideFolder),fullName),!isPathAlreadyPresent(fileURL.path) {
            do {
                try data.write(to: fileURL)
            } catch {
                NSLog(error.localizedDescription)
            }
        } else {
            NSLog("Failed to create path |or| Path is already present")
        }
    }
    
    /// getData(name: dataExtension: insideFolder:)
    /// return Data? that is present in document directory matching the name and extension ( if given ) and if it was sved inside a folder you can specify that as well
    /// - Parameters:
    ///   - name: name of file that was saved to document directory
    ///   - dataExtension: extension that was given to the file at the time of saving the file
    ///   - insideFolder: optional field if the file was saved inside an folder
    /// - Returns: return the Data if found else return nil
    public func getData(name:String,dataExtension:String?=nil,insideFolder:String?=nil) -> Data? {
        let fullName = "\(name)\(dataExtension ?? "")"
        if let fileURL = createUrlPath(directoryURL:getFolderURL(from: insideFolder),fullName) {
            let data = fm.contents(atPath: fileURL.path)
            return data
        }
        return nil
        
    }
    
    /// deleteData(name:dataExtension:insideFolder:)
    /// deletes the file at document directory
    /// - Parameters:
    ///   - name: name of file that was saved to document directory
    ///   - dataExtension: extension that was given to the file at the time of saving the file
    ///   - insideFolder: optional field if the file was saved inside an folder
    public func deleteData(name:String,dataExtension:String?=nil,insideFolder:String?=nil) {
        let fullName = "\(name)\(dataExtension ?? "")"
        if let fileURL = createUrlPath(directoryURL:getFolderURL(from: insideFolder),fullName) {
            do {
                try fm.removeItem(atPath: fileURL.path)
            } catch {
                NSLog(error.localizedDescription)
            }
        }
    }
    
    /// getAllDataList(from:)
    /// gives all the files that are present, but only from inside the folder
    /// - Parameter folderName: name of the folder inside which the files are saved
    /// - Returns: return an array of Data which were found inside folder. an empty array if did't found any
    public func getAllDataList(from folderName:String) -> [Data] {
        
        var allData:[Data] = []
        
        if let folderURL = getFolderURL(from: folderName) {
            for url in getAllFileURLs(from: folderURL) {
                if let data = fm.contents(atPath: url.path) {
                    allData.append(data)
                }
            }
        }
        
        return allData
    }
    
    /// prints all the files that are present inside  documet directory
    public func printAllAvailableFilesInDirectory() {
        guard let docURL = DDURL else {return}
        
        let dict = fm.enumerator(at: docURL, includingPropertiesForKeys: nil)
        var count = 0
        while let element = dict?.nextObject() as? URL {
            print(element.relativePath)
            count += 1
        }
        print("\n---- total files ---- \(count)")
    }
    
    // private functions
    
    private func getFolderURL(from name:String?) -> URL? {
        
        guard let name = name else { return nil }
        
        if let fileURL = createUrlPath(name) {
            
            if !isPathAlreadyPresent(fileURL.path) {
                createFolder(fileURL)
            }
            
            return fileURL
        }
        
        return nil
    }
    
    private func createUrlPath(directoryURL:URL?=nil,_ name:String) -> URL? {
        if let directoryURL = directoryURL {
            let fileURL = directoryURL.appendingPathComponent(name)
            return fileURL
        }
        else if let documentDirectry = DDURL {
            let fileURL = documentDirectry.appendingPathComponent(name)
            return fileURL
        }
        return nil
    }
    
    private func createFolder(_ fileURL:URL) {
        do {
            try fm.createDirectory(at: fileURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    private func isPathAlreadyPresent(_ filePath:String) -> Bool {
        if fm.fileExists(atPath: filePath) {
            return true
        }
        return false
    }
    
    private func getAllFileURLs(from filePath:URL) -> [URL] {
        do {
            let urls = try fm.contentsOfDirectory(at: filePath, includingPropertiesForKeys: [URLResourceKey.creationDateKey])
            return sort(urlArray: urls)
        } catch {
            NSLog(error.localizedDescription)
        }
        return []
    }
    
    private func sort(urlArray:[URL]) -> [URL] {
        let res =  urlArray.sorted { (url1, url2) -> Bool in
            do {
                let values1 = try url1.resourceValues(forKeys: [.creationDateKey])
                let values2 = try url2.resourceValues(forKeys: [.creationDateKey])
                
                if let date1 = values1.creationDate, let date2 = values2.creationDate {
                    return date1.compare(date2) == ComparisonResult.orderedDescending
                }
            } catch{
                NSLog("Error occured while Ordering the URLs")
            }
            return true
        }
        return res
    }
    
}
