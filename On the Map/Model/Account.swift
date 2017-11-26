//
// Created by Niklas Rammerstorfer on 26.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

struct Account {

    // MARK: Properties

    private(set) var ID: String
    private(set) var firstName: String
    private(set) var lastName: String

    // MARK: Initialization

    init(id: String, firstName: String, lastName: String){
        ID = id
        self.firstName = firstName
        self.lastName = lastName
    }
}
