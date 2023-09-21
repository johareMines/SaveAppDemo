//
//  ContentView.swift
//  Test App
//
//  Created by Jimmy O'Hare (Student) on 9/9/23.
//

import SwiftUI

struct ContentView: View {
    @State private var userInput: String = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Enter filename (duplicate names will be overwritten)")
                .padding()
            
            TextField("Enter text", text: $userInput) // Create a TextField
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                save(userInput: userInput)
            }) {
                Text("Save")
                    .padding()
            }
            Button(action: printData) {
                Text("Check Saved Data")
                    .padding()
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Sample data to save to filesystem:
let jsonDict: [String: Any] = [  //[String: Any] means key=string, value=any
    "name": "luukie puukie",
    "age": 69,
    "city": "Porktown USA"
]

func save (userInput: String){
    print("The Save button was pressed")
    
    do {
        //Convert dict object to jsonData
        //Pretty printed = human readable
        let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
        
        //Get Application Support directory
        if let appSupportDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            
            
            let dataFolderURL = appSupportDirectory.appendingPathComponent("data")
            
            //Create data folder if it doesn't exist
            do {
                try FileManager.default.createDirectory(at: dataFolderURL, withIntermediateDirectories: true)
            } catch {
                print("Error creating data folder: \(error)")
                return
            }
            
            let filename = userInput + ".json"
            let fileURL = dataFolderURL.appendingPathComponent(filename)
            
            
            do {
                try jsonData.write(to: fileURL)
                print("JSON successfully saved to: \(fileURL)")
            } catch {
                print("Error saving JSON file: \(error)")
            }
            
        } else {
            print("Error fetching appSupportDirectory")
        }
        
    } catch {
        print("Error serializing JSON: \(error)")
    }
}


func printData() {
    print("printing")
    
    // App Sandbox Directory
    if let appSupportDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
        
        do {
            let dataFolderURL = appSupportDirectory.appendingPathComponent("data")
            
            // List of all files in directory
            let fileList = try FileManager.default.contentsOfDirectory(at: dataFolderURL, includingPropertiesForKeys: nil, options: [])
            
            for file in fileList {
                
                // Ensure file (not directory)
                if file.hasDirectoryPath == false {
                    do {
                        // Read the content of file
                        let fileData = try Data(contentsOf: file)
                        
                        // Convert data to String
                        if let fileContent = String(data: fileData, encoding: .utf8) {
                            
                            print("File Name: \(file.lastPathComponent)")
                            print("File Content:")
                            print(fileContent)
                        }
                    } catch {
                        // Handle errors while reading the file
                        print("Error reading file: \(file.lastPathComponent) - \(error)")
                    }
                }
            }
        } catch {
            // Handle errors while listing directory contents
            print("Error listing directory contents: \(error)")
        }
    }
}
