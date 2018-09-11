//
//  VideoTableViewController.swift
//  ViewBook
//
//  Created by Dave Myers on 9/7/18.
//  Copyright © 2018 Drexel University School of Biomedical Engineering, Science and Health Systems. All rights reserved.
//

import UIKit

class VideoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var tableView: UITableView!
    var videos = [[Video]]()
    var selected: Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingService.shared.getVideos { (videos) in
            self.videos = VideoCollection(videos: videos).videosByCategory()
            self.tableView.reloadData()
        }
        self.tableView.register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: CustomTableViewHeader.reuseIdentifer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return videos.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tcell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as! VideoTableViewCell
        tcell.videos = videos[indexPath.section]

        return tcell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomTableViewHeader.reuseIdentifer) as? CustomTableViewHeader {
            header.customLabel.text = videos[section][0].category
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? VideoTableViewCell else { return }
        print(indexPath.section)
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
    }
    
    // MARK: - Collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath)
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "watchVideoSegue" {
            if let cell = sender as? VideoCell {
                if let collectionView = cell.superview as? UICollectionView {
                    if let destination = segue.destination as? WatchVideoViewController {
                        let row = videos[collectionView.tag]
                        let index = row.index(where: {$0.title == cell.titleLabel.text})
                        if let index = index {
                            destination.thisVideo = videos[collectionView.tag][index]
                        }
                    }
                }
            }
        }
//            let indexPath = self.collectionView.indexPath(for: cell) {
//             let vc = segue.destination as! WatchVideoViewController
//             vc.thisVideo = videos[indexPath.section][indexPath.item]
    }
//      Pass the selected object to the new view controller.
}
