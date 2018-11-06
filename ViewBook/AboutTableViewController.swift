//
//  AboutTableViewController.swift
//  ViewBook
//
//  Created by Dave Myers on 10/30/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

class AboutTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var aboutModel = AboutModel()
    var aboutRow = AboutRow()
    var currentContent = ""
    var urlString = ""
    var priorities = [String]()
    var ignore = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlString = "https://drexel.edu/biomed/resources/faculty-and-staff/about"
        priorities = ["visit", "contact", "message", "facts", "feedback"]
        ignore = ["director", "thank you"]
        Spinner.start(style: .whiteLarge, background: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2), foreground: #colorLiteral(red: 0, green: 0.3796961904, blue: 0.6040052772, alpha: 1))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        beginParsing(urlString: urlString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ViewBook.AboutCell {
            let row = indexPath.row
            cell.configure(with: aboutModel.data[row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    
    //MARK: - Begin Parsing
    func beginParsing(urlString:String){
        guard let myURL = URL(string:urlString) else {
            print("URL not defined properly")
            return
        }
        guard let parser = XMLParser(contentsOf: myURL) else {
            print("Cannot Read Data")
            return
        }
        parser.delegate = self
        aboutModel = AboutModel()
        if !parser.parse(){
            print("Data Errors Exist:")
            let error = parser.parserError!
            print("Error Description:\(error.localizedDescription)")
            print("Line number: \(parser.lineNumber)")
        }
    }
    
    //MARK: XMLParser delegates
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        if elementName == "item"{
            aboutRow = AboutRow()
        }
        currentContent = ""
    }
    
    //the middle of an element
    //append the string for the element
    func parser(_ parser: XMLParser, foundCharacters string: String){
        currentContent += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        switch elementName {
        case "item":
            aboutModel.addRow(row: aboutRow)
        case "title":
            aboutRow.headline = currentContent
        case "description":
            aboutRow.summary = currentContent
        case "link":
            aboutRow.link = currentContent
        default:
            return
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.aboutModel.data = self.aboutModel
                    .sortBy(arrayOfMatchStrings: self.priorities, arrayOfIgnoreStrings: self.ignore, aboutData: self.aboutModel.data)
            self.tableView.reloadData()
            Spinner.stop()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
