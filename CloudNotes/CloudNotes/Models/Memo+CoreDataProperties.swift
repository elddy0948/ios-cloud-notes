//
//  Memo+CoreDataProperties.swift
//  CloudNotes
//
//  Created by 김호준 on 2021/02/26.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var title: String
    @NSManaged public var body: String?
    @NSManaged public var lastModified: Int64

}

extension Memo : Identifiable {

}
