//
//  String+Log.swift
//  MapWidget
//
//  Created by Felix Mau on 15.10.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import Foundation

/// Based on: https://gist.github.com/fxm90/08a187c5d6b365ce2305c194905e61c2
extension String {
    // MARK: - Types

    enum LogLevel {
        case info
        case error
    }

    // MARK: - Private properties

    /// Returns the current date/time as string.
    private var logDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"

        let now = Date()
        return dateFormatter.string(from: now)
    }

    // MARK: - Public methods

    func log(level: LogLevel, file: String = #file, function: String = #function, line: UInt = #line) {
        #if DEBUG
            var logString: String
            switch level {
            case .info:
                logString = "ℹ️ – "

            case .error:
                logString = "⚠️ – "
            }

            let logPrefix = self.logPrefix(fileName: extractFilename(from: file),
                                           functionName: function,
                                           line: line)

            logString += "\(logDate) - \(logPrefix)\n"
            logString += "> \(self)\n"

            print(logString)
        #endif
    }

    // MARK: - Private methods

    /// Extracts the filename of the entire path.
    private func extractFilename(from filePath: String) -> String {
        URL(fileURLWithPath: filePath).lastPathComponent
    }

    /// Returns the prefix (containing file name, function name and line) for the log statement.
    private func logPrefix(fileName: String, functionName: String, line: UInt) -> String {
        "\(fileName) - \(functionName):\(line)"
    }
}
