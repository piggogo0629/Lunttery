//
//  Validate.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/8.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import Foundation

extension String {
    func isBlank() -> Bool {
            let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return trimmed.isEmpty
    }
    
    func isEmail() throws -> Bool {
        let regexString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        
        let emailRegex = try NSRegularExpression(pattern: regexString, options: NSRegularExpression.Options.caseInsensitive)
        
        // NSRegularExpression.MatchingOptions.init(rawValue: 0) -> caseInsensitive
        return emailRegex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange(location: 0, length: self.utf16.count)) != nil
    }
}
