//
//  TableTabbedViewController.swift
//  On the Map
//
//  Created by Niklas Rammerstorfer on 26.11.17.
//  Copyright © 2017 Niklas Rammerstorfer. All rights reserved.
//

import UIKit

class TableTabbedViewController: BaseTabbedViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: Constants

    private struct Identifiers{
        static let ReusableCell = "studentLocationCell"
        static let TableCellImageView = "icon_pin"
        static let AddLocationSegue = "PresentAddLocationSceneFromTableScene"
    }
    
    // MARK: Initialization.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didFinishLoadingStudentLocations(success: Bool, error: ParseAPIClient.APIError?) {
        tableView.reloadData()
    }

    // MARK: Navigation

    override func segueIdentifierAddLocation() -> String {
        return Identifiers.AddLocationSegue
    }
}

// MARK: Extension for UITableViewDelegate and UITableViewDataSource
extension TableTabbedViewController: UITableViewDelegate, UITableViewDataSource{

    // MARK: DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocationRepository.studentLocations.count
    }

    // MARK: Delegate

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentLocation = studentLocationRepository.studentLocations[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ReusableCell)!

        cell.imageView!.image = UIImage(named: Identifiers.TableCellImageView)
        cell.textLabel!.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.detailTextLabel!.text = studentLocation.mediaURL

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let studentLocation = studentLocationRepository.studentLocations[indexPath.row]

        AppDelegate.openURL(urlString: studentLocation.mediaURL)
    }
}
