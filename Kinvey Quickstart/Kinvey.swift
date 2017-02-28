//
//  Client.swift
//  Kinvey Test Drive
//
//  Created by Victor Hugo on 2017-02-27.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey

@objc
class KinveyClient: NSObject {
    
    static let sharedClient = KinveyClient(Client.sharedClient)
    
    let client: Client
    
    var activeUser: User? {
        return client.activeUser
    }
    
    init(_ client: Client) {
        self.client = client
    }
    
    func initialize(appKey: String, appSecret: String) {
        client.initialize(appKey: appKey, appSecret: appSecret) { user, error in
        }
    }
    
}

@objc
class KinveyRequest: NSObject {
    
    /// Indicates if a request still executing or not.
    var executing: Bool {
        return request.executing
    }
    
    /// Indicates if a request was cancelled or not.
    var cancelled: Bool {
        return request.cancelled
    }
    
    /// Cancels a request in progress.
    func cancel() {
        request.cancel()
    }
    
    /// Report upload progress of the request
    var progress: ((ProgressStatus) -> Void)? {
        get {
            return request.progress
        }
        set {
            request.progress = progress
        }
    }
    
    let request: Request
    
    init(_ request: Request) {
        self.request = request
    }
    
}

@objc
class KinveyConstants: NSObject {
    
    static let persistableMetadataKey = PersistableMetadataKey
    
    static let metadataLastModifiedTimeKey = Metadata.LmtKey
    
}

@objc
class KinveyDataStoreTestObject: NSObject {
    
    let dataStore = DataStore<TestObject>.collection(.network)
    
    func save(_ testObject: TestObject, completionHandler: ((TestObject?, Swift.Error?) -> Void)?) -> KinveyRequest {
        return KinveyRequest(dataStore.save(testObject, completionHandler: completionHandler))
    }
    
    func find(_ query: Query, completionHandler: @escaping (([TestObject]?, Swift.Error?) -> Void)) -> KinveyRequest {
        return KinveyRequest(dataStore.find(query, completionHandler: completionHandler))
    }
    
    func remove(_ testObject: TestObject, completionHandler: ((Int, Swift.Error?) -> Void)?) -> KinveyRequest {
        let request = try! dataStore.remove(testObject) { (count, error) in
            completionHandler?(count ?? 0, error)
        }
        return KinveyRequest(request)
    }
    
}

extension User {
    
    class func signUp(completionHandler: ((User?, Swift.Error?) -> Void)?) -> KinveyRequest {
        let request = signup(completionHandler: completionHandler)
        return KinveyRequest(request)
    }
    
}
