# QCFileManager

A small set of functions which helps to save and retrive 'Data' format locally. No need to store data in UserDefault because it loads all the saved data at Launch, so more the data more it takes time to launch the app. CoreData is a sophisticated way of saving data which needs time so, best thing is to save it in User's directry and with 'QCFileManager' you don't need to write complex code to access files, we will handle all that for you!.

## Usage

* saveData(data:name:dataExtension:insideFolder:)
```swift
    /// This method helps in saving data type to document directry.
    ///     You should give a nuique name to it that does't matches any previous data saved 
    ///     otherwise the data will not be saved. You can also save data by creating a folder,
    ///     you just need to provide the name of the the folder.
    /// - Parameters:
    ///   - data: Data which you want to save in document directory
    ///   - name: name of this file ( must be unique )
    ///   - dataExtension: an optional field that provides extension to the file
    ///   - insideFolder: an optional filed that, if you want ot save the file inside a folder 
    ///        then specify that folders name if the folder is already present it will be saved 
    ///        there or a new folder will be created
    
    QCFileManager.shared.saveData(data: Data(), name: "", dataExtension: "", insideFolder: "")
```
* getData(name: dataExtension: insideFolder:)
```swift
    /// return Data? that is present in document directory matching the name and extension ( if given )
    ///     and if it was sved inside a folder you can specify that as well
    /// - Parameters:
    ///   - name: name of file that was saved to document directory
    ///   - dataExtension: extension that was given to the file at the time of saving the file
    ///   - insideFolder: optional field if the file was saved inside an folder
    /// - Returns: return the Data if found else return nil
    
    QCFileManager.shared.getData(name:"", dataExtension:"", insideFolder:"")
```
* deleteData(name:dataExtension:insideFolder:)
```swift
/// deletes the file at document directory
    /// - Parameters:
    ///   - name: name of file that was saved to document directory
    ///   - dataExtension: extension that was given to the file at the time of saving the file
    ///   - insideFolder: optional field if the file was saved inside an folder

    QCFileManager.shared.deleteData(name: "", dataExtension: "", insideFolder: "")
```
* getAllDataList(from:)
```swift
/// gives all the files that are present, but only from inside the folder
    /// - Parameter folderName: name of the folder inside which the files are saved
    /// - Returns: return an array of Data which were found inside folder. an empty array if did't found any

    QCFileManager.shared.getAllDataList(from: "")
```
* printAllAvailableFilesInDirectory()
```swift
/// prints all the files that are present inside  documet directory

    QCFileManager.shared.printAllAvailableFilesInDirectory()
```
