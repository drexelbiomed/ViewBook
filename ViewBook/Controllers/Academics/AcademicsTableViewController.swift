//
//  AcademicsTableViewController.swift
//  ViewBook
//
//  Created by Dave Myers on 10/2/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

class AcademicsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var academicsModel = AcademicsModel()
    var academicsRow = AcademicsRow()
    var currentContent = ""
    var urlString = ""
    var priorities = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        urlString = "https://drexel.edu/biomed/resources/faculty-and-staff/undergraduate-programs"
        priorities = ["bachelor", "degree", "co-ops", "co-op", "design"]

        segmentedControl.addTarget(self, action: #selector(AcademicsTableViewController.segmentedControlValueChanged), for: UIControl.Event.valueChanged)
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
        return academicsModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ViewBook.AcademicsCell {
            let row = indexPath.row
            cell.configure(with: academicsModel.data[row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    
    //MARK: Begin Parsing 
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
        academicsModel = AcademicsModel()
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
            academicsRow = AcademicsRow()
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
            academicsModel.addRow(row: academicsRow)
        case "title":
            academicsRow.headline = currentContent
        case "description":
            academicsRow.summary = currentContent
        case "link":
            academicsRow.link = currentContent
        default:
            return
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.academicsModel.data = self.academicsModel.sortBy(arrayOfMatchStrings: self.priorities, academicsData: self.academicsModel.data)
            self.tableView.reloadData()
            Spinner.stop()
            self.scrollToFirstRow()
        }
    }
    
    //MARK: - Segmented Control Code
    
    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
        Spinner.start(style: .whiteLarge, background: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3279599472), foreground: #colorLiteral(red: 0, green: 0.3796961904, blue: 0.6040052772, alpha: 1))

        if segment.selectedSegmentIndex == 0 {
            urlString = "https://drexel.edu/biomed/resources/faculty-and-staff/undergraduate-programs"
            priorities = ["bachelor", "degree", "co-ops", "co-op", "design"]
        } else if segment.selectedSegmentIndex == 1 {
            urlString = "https://drexel.edu/biomed/resources/faculty-and-staff/graduate-programs"
            priorities = ["master of science (ms) in biomedical", "business", "phd", "international", "minor"]
        } else {
            urlString = "https://drexel.edu/biomed/resources/faculty-and-staff/certificate-programs"
            priorities = ["tissue", "bioinformatics"]
        }

        beginParsing(urlString: urlString)
    }
    
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func scrollToTop(){
        self.tableView.setContentOffset(CGPoint(x: 0,  y: UIApplication.shared.statusBarFrame.height ), animated: true)
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
