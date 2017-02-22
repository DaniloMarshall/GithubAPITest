//
//  GitTestError.swift
//  GithubAPITest
//
//  Created by Danilo S Marshall on 22/02/17.
//  Copyright © 2017 danilomarshall. All rights reserved.
//

import Foundation

enum GitTestError: Error {
    case InvalidConfigurations
    
    case UnableToConnectToServer
    case UnexpectedServerResponse
    case ServerRespondedWithError(httpErrorCode: Int)
    
    case AuthenticationFailed
    case NotAuthenticated
}
