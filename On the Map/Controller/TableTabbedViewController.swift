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
        static let StudentInformationCell = "StudentInformationCell"
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

    override func didFinishLoadingStudentInformations(success: Bool, error: ParseAPIClient.APIClientError?) {
        tableView.reloadData()
    }

    override func segueIdentifierForInformationPostingView() -> String {
        return AppDelegate.Identifiers.Segues.InformationPostingFromTableView
    }
}

// MARK: Extension for UITableViewDelegate and UITableViewDataSource

extension TableTabbedViewController: UITableViewDelegate, UITableViewDataSource{

    // MARK: DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformationRepository.studentInformations.count
    }

    // MARK: Delegate

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentInformation = studentInformationRepository.studentInformations[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.StudentInformationCell)!

        cell.textLabel!.text = "\(studentInformation.firstName) \(studentInformation.lastName)"
        cell.detailTextLabel!.text = studentInformation.mediaURL

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let studentInformation = studentInformationRepository.studentInformations[indexPath.row]
        AppDelegate.openURL(urlString: studentInformation.mediaURL)
    }
}
