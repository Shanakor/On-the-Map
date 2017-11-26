//
//  TableTabbedViewController.swift
//  On the Map
//
//  Created by Niklas Rammerstorfer on 26.11.17.
//  Copyright © 2017 Niklas Rammerstorfer. All rights reserved.
//

import UIKit

class TableTabbedViewController: BaseTabbedViewController {

    // MARK: Constants

    private struct Identifiers{
        static let StudentLocationCell = "StudentLocationCell"
    }

    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: Initialization.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: BaseTabbedViewController members

    override func didFinishLoadingStudentLocations(success: Bool, error: ParseAPIClient.APIClientError?) {
        tableView.reloadData()
    }

    override func segueIdentifierForInformationPostingView() -> String {
        return Identifiers.InformationPostingSegue
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

        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.StudentLocationCell)!

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
