//
//  NewsViewControllerTableViewController.swift
//  ViewBook
//
//  Created by Dave Myers on 9/12/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit
import Foundation

class NewsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var newsModel = NewsModel()
    var newsRow = NewsRow()
    var currentContent = ""
    var urlString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlString = "https://drexel.edu/biomed/news"
        
        segmentedControl.addTarget(self, action: #selector(NewsTableViewController.segmentedControlValueChanged), for: UIControl.Event.valueChanged)

        Spinner.start(style: .whiteLarge, background: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2), foreground: #colorLiteral(red: 0, green: 0.3796961904, blue: 0.6040052772, alpha: 1))
        segmentedControl.layer.cornerRadius = 3.0
        segmentedControl.alpha = 1.0
        segmentedControl.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        beginParsing(urlString: urlString)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsModel.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsCell {
            let row = indexPath.row
            // Configure Cell
            cell.configure(with: newsModel.data[row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    //MARK: - XML Parsing Code
    
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
        newsModel = NewsModel()
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
            newsRow = NewsRow()
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
            newsModel.addRow(row: newsRow)
        case "title":
            newsRow.headline = currentContent
        case "description":
            newsRow.summary = currentContent
        case "pubDate":
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE, d MMM yyyy HH:mm:ss zzz"
            dateFormatter.locale = Locale(identifier: "en_US")
            if let date = dateFormatter.date(from: currentContent) {
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .none
                newsRow.pubDate = dateFormatter.string(from: date)
            }
        case "link":
            newsRow.link = currentContent
        default:
            return
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
//        print("Did end document")
        DispatchQueue.main.async {
            self.tableView.reloadData()
            Spinner.stop()
            self.scrollToFirstRow()
        }
    }
    
    //MARK: - Segmented Control Code
    
    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
        Spinner.start(style: .whiteLarge, background: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3279599472), foreground: #colorLiteral(red: 0, green: 0.3796961904, blue: 0.6040052772, alpha: 1))
        
        if segment.selectedSegmentIndex == 0 {
            urlString = "https://drexel.edu/biomed/news"
        } else if segment.selectedSegmentIndex == 1 {
            urlString = "https://drexel.edu/now/biomed-news"
        } else {
            urlString = "https://newsblog.drexel.edu/tag/school-of-biomedical-engineering-science-and-health-systems/feed/"
        }
        beginParsing(urlString: urlString)
    }
    
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
