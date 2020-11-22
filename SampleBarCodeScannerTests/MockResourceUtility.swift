//
//  MockResourceHelper.swift
//  SampleBarCodeScannerTests
//
//  Created by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

class MockResourceUtility {
    
    private init() {}
    
    static func json(named filename: String) -> [String: Any] {
        guard
            let path = path(forFile: filename, ofType: "json"),
            let data =  try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            else {
                return [:]
        }
        return json as? [String: Any] ?? [:]
    }
    
    static func data(named filename: String) -> Data? {
        guard
            let path = path(forFile: filename, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
                return nil
        }
        return data
    }
    
    static func path(forFile filename: String, ofType type: String) -> String? {
        return Bundle(for: MockResourceUtility.self).path(forResource: filename, ofType: type)
    }
}

