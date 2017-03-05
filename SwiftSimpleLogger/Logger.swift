//
//  Logger.swift
//  Showroom
//
//  Created by Alexander Weleczka on 03.03.17.
//  Copyright © 2017 AWeleczka.de - All rights reserved.
//

import Foundation

/// Simple single-file logging for Swift 3
/// Logging to XCode-Console, file (for error-reporting) or remote Web-API
open class Logger: NSObject {

    /// Available Log-Message-Levels
    internal enum LogLevel: String {
        /// Trace-Message
        case Trace      = "TRC"

        /// Debug-Message
        case Debug      = "DBG"

        /// INFO-Message
        case Info       = "INF"

        /// WARNING-Message
        case Warning    = "WRN"

        /// ERROR-Message
        case Error      = "ERR"
    }

    /// Allow logging to XCode-Console
    open static var AllowConsoleLog: Bool = true

    /// Restrict console-output to these LogLevels
    open static var ConsoleLogLevels: [Logger.LogLevel] = [.Trace, .Debug, .Info, .Warning, .Error]

    /// Allow logging to logfile
    open static var AllowLocalLog: Bool = true

    /// Restrict logfile-output to these LogLevels
    open static var LocalLogLevels: [Logger.LogLevel] = [.Info, .Warning, .Error]

    /// Name of the logfile in the application directory
    open static var LocalLogFile: String = "application.log"

    /// Allow logging to Remote-Script
    open static var AllowRemoteLog: Bool = true

    /// Restrict remote-output to these LogLevels
    open static var RemoteLogLevels: [Logger.LogLevel] = [.Warning, .Error]

    /// URL of the Remote-Script
    open static var RemoteLogURL: String = ""

    /// Identifyer-String of this session
    open static var RemoteIdentifier: String = ""

    /**
        Initialize Logger-Settings directly.

        - parameter allowconsolelog: Allow logging to XCode-Console
        - parameter consoleloglevels: Restrict console-output to these LogLevels
        - parameter allowlocallog: Allow logging to logfile
        - parameter localloglevels: Restrict logfile-output to these LogLevels
        - parameter locallogfile: Name of the logfile in the application directory
        - parameter allowremotelog: Allow logging to Remote-Script
        - parameter remoteloglevels: Restrict remote-output to these LogLevels
        - parameter remotelogurl: URL of the Remote-Script
        - parameter remoteidentifyer: Identifyer-String of this session
    */
    open init(allowconsolelog: Bool = true, consoleloglevels: [Logger.LogLevel] = [.Trace, .Debug, .Info, .Warning, .Error], allowlocallog: Bool = true, localloglevels: [Logger.LogLevel] = [.Info, .Warning, .Error], locallogfile: String = "Application.log", allowremotelog: Bool = false, remoteloglevels: [Logger.LogLevel] = [.Warning, .Error], remotelogurl: String = "", remoteidentifier: String = "") {
        Logger.AllowConsoleLog  = allowconsolelog
        Logger.ConsoleLogLevels = consoleloglevels

        Logger.AllowLocalLog    = allowlocallog
        Logger.LocalLogLevels   = localloglevels
        Logger.LocalLogFile     = locallogfile

        Logger.AllowRemoteLog   = allowremotelog
        Logger.RemoteLogLevels  = remoteloglevels
        Logger.RemoteLogURL     = remotelogurl
        Logger.RemoteIdentifier = remoteidentifier
    }

    // MARK: - Log-Methods

    /**
        Log Function-Access as TRACE

        - parameter file: Do not declare - passing the file-name along
        - parameter line: Do not declare - passing the line-number along
        - parameter column: Do not declare - passing the column-number along
        - parameter function: Do not declare - passing the function-name along
    */
    open static func access(_ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = "Accessed function \"\(function)\""
        let timestamp   = Date()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(Logger.LogLevel.Trace, timestamp, message, position)
        Logger.localline(Logger.LogLevel.Trace, timestamp, message, position)
        Logger.remoteline(Logger.LogLevel.Trace, timestamp, message, position)
    }

    /**
        Log Memory-Warning as WARNING

        - parameter file: Do not declare - passing the file-name along
        - parameter line: Do not declare - passing the line-number along
        - parameter column: Do not declare - passing the column-number along
        - parameter function: Do not declare - passing the function-name along
     */
    open static func memory( _ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = "\"\(file.components(separatedBy: "/").last ?? "")\" received a memory-warning"
        let timestamp   = Date()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(Logger.LogLevel.Warning, timestamp, message, position)
        Logger.localline(Logger.LogLevel.Warning, timestamp, message, position)
        Logger.remoteline(Logger.LogLevel.Warning, timestamp, message, position)
    }

    /**
        Log a message as TRACE

        - parameter format: Format or String of the message
        - parameter args: Args used in format
        - parameter file: Do not declare - passing the file-name along
        - parameter line: Do not declare - passing the line-number along
        - parameter column: Do not declare - passing the column-number along
        - parameter function: Do not declare - passing the function-name along
    */
    open static func trace(format: String, _ args: CVarArg..., _ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = String(format: format, args)
        let timestamp   = Date()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(Logger.LogLevel.Trace, timestamp, message, position)
        Logger.localline(Logger.LogLevel.Trace, timestamp, message, position)
        Logger.remoteline(Logger.LogLevel.Trace, timestamp, message, position)
    }

    /**
        Log a message as DEBUG

        - parameter format: Format or String of the message
        - parameter args: Args used in format
        - parameter file: Do not declare - passing the file-name along
        - parameter line: Do not declare - passing the line-number along
        - parameter column: Do not declare - passing the column-number along
        - parameter function: Do not declare - passing the function-name along
     */
    open static func debug(format: String, _ args: CVarArg..., _ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = String(format: format, args)
        let timestamp   = Date()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(Logger.LogLevel.Debug, timestamp, message, position)
        Logger.localline(Logger.LogLevel.Debug, timestamp, message, position)
        Logger.remoteline(Logger.LogLevel.Debug, timestamp, message, position)
    }

    /**
        Log a message as INFO

        - parameter format: Format or String of the message
        - parameter args: Args used in format
        - parameter file: Do not declare - passing the file-name along
        - parameter line: Do not declare - passing the line-number along
        - parameter column: Do not declare - passing the column-number along
        - parameter function: Do not declare - passing the function-name along
    */
    open static func info(format: String, _ args: CVarArg..., _ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = String(format: format, args)
        let timestamp   = Date()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(Logger.LogLevel.Info, timestamp, message, position)
        Logger.localline(Logger.LogLevel.Info, timestamp, message, position)
        Logger.remoteline(Logger.LogLevel.Info, timestamp, message, position)
    }

    /**
        Log a message as WARNING

        - parameter format: Format or String of the message
        - parameter args: Args used in format
        - parameter file: Do not declare - passing the file-name along
        - parameter line: Do not declare - passing the line-number along
        - parameter column: Do not declare - passing the column-number along
        - parameter function: Do not declare - passing the function-name along
    */
    open static func warning(format: String, _ args: CVarArg..., _ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = String(format: format, args)
        let timestamp   = Date()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(Logger.LogLevel.Warning, timestamp, message, position)
        Logger.localline(Logger.LogLevel.Warning, timestamp, message, position)
        Logger.remoteline(Logger.LogLevel.Warning, timestamp, message, position)
    }

    /**
        Log a message as ERROR

        - parameter format: Format or String of the message
        - parameter args: Args used in format
        - parameter file: Do not declare - passing the file-name along
        - parameter line: Do not declare - passing the line-number along
        - parameter column: Do not declare - passing the column-number along
        - parameter function: Do not declare - passing the function-name along
     */
    open static func error(format: String, _ args: CVarArg..., _ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = String(format: format, args)
        let timestamp   = Date()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(Logger.LogLevel.Error, timestamp, message, position)
        Logger.localline(Logger.LogLevel.Error, timestamp, message, position)
        Logger.remoteline(Logger.LogLevel.Error, timestamp, message, position)
    }

    /**
        Log an error as ERROR

        - parameter error: The Error-Object
        - parameter file: Do not declare - passing the file-name along
        - parameter line: Do not declare - passing the line-number along
        - parameter column: Do not declare - passing the column-number along
        - parameter function: Do not declare - passing the function-name along
     */
    open static func error(error: Error, _ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = "Error# \(error._code) occured \"\(error.localizedDescription)\""
        let timestamp   = Date()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(Logger.LogLevel.Error, timestamp, message, position)
        Logger.localline(Logger.LogLevel.Error, timestamp, message, position)
        Logger.remoteline(Logger.LogLevel.Error, timestamp, message, position)
    }

    // MARK: - Housekeeping

    /**
        Return and delete local log

        - returns: The current logfile-content before deletion
     */
    open static func flushLocalLog() -> String {
        if let logfile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, !Logger.LocalLogFile.isEmpty {
            let logfile = logfile.appendingPathComponent(Logger.LocalLogFile)
            do {
                let log = try String(contentsOf: logfile, encoding: String.Encoding.utf8)
                try FileManager.default.removeItem(at: logfile)

                return log
            } catch {
                Logger.error(format: "Unable to delete file")
            }
        }

        return ""
    }

    /**
        Remove local logfile
    */
    open static func deleteLocalLog() {
        if let logfile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, !Logger.LocalLogFile.isEmpty {
            let logfile = logfile.appendingPathComponent(Logger.LocalLogFile)
            do {
                try FileManager.default.removeItem(at: logfile)
            } catch {
                Logger.error(format: "Unable to delete file")
            }
        }

    }

    // MARK: - Internal Logging Logic

    /**
        Log data to XCode-Console

        - parameter loglevel: Loge-Level of log-call
        - parameter timestamp: Synchronized timestamp of log-call
        - parameter message: Pre-Parsed log-message
        - parameter position: Pre-Parsed in-code-position of log-call
    */
    private static func consoleline(_ loglevel: Logger.LogLevel, _ timestamp: Date, _ message: String, _ position: String) {
        if Logger.AllowConsoleLog && Logger.ConsoleLogLevels.contains(loglevel) {
            DispatchQueue(label: "Logger.consoleline").async {
                Swift.print(">> \(Logger.parseAccurateDate(date: timestamp)) > \(loglevel.rawValue) @ \(position) : \(message)")
            }
        }
    }

    /**
        Log data to local file

        - parameter loglevel: Loge-Level of log-call
        - parameter timestamp: Synchronized timestamp of log-call
        - parameter message: Pre-Parsed log-message
        - parameter position: Pre-Parsed in-code-position of log-call
     */
    private static func localline(_ loglevel: Logger.LogLevel, _ timestamp: Date, _ message: String, _ position: String) {
        if Logger.AllowLocalLog && Logger.LocalLogLevels.contains(loglevel) {
            if let logfile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, !Logger.LocalLogFile.isEmpty {
                DispatchQueue(label: "Logger.localline").async {
                    let logfile = logfile.appendingPathComponent(Logger.LocalLogFile)
                    let logline = "\(Logger.parseAccurateDate(date: timestamp)) > \(loglevel.rawValue) @ \(position) : \(message)\n"

                    do {
                        if !FileManager.default.fileExists(atPath: logfile.relativePath) {
                            try logline.write(to: logfile, atomically: false, encoding: String.Encoding.utf8)
                        } else {
                            if let logdata: Data = logline.data(using: String.Encoding.utf8) {
                                let handle = try FileHandle(forWritingTo: logfile)
                                handle.seekToEndOfFile()
                                handle.write(logdata)
                                handle.closeFile()
                            }
                        }
                    } catch let error {
                        Logger.AllowLocalLog = false
                        Logger.error(format: "Unable to log to local file - disabling local-logging")
                        Logger.error(error: error)
                    }

                }
            }
        }
    }

    /**
        Log data to remote API

        - parameter loglevel: Loge-Level of log-call
        - parameter timestamp: Synchronized timestamp of log-call
        - parameter message: Pre-Parsed log-message
        - parameter position: Pre-Parsed in-code-position of log-call
    */
    private static func remoteline(_ loglevel: Logger.LogLevel, _ timestamp: Date, _ message: String, _ position: String) {
        if Logger.AllowRemoteLog && Logger.RemoteLogLevels.contains(loglevel) {
            if let remotefile: URL = URL(string: Logger.RemoteLogURL) {
                DispatchQueue(label: "Logger.remoteline").async {
                    let postdata = "loglevel=\(loglevel.rawValue)&timestamp=\(Logger.parseAccurateDate(date: timestamp))&message=\(message)&position=\(position)&identifier=\(Logger.RemoteIdentifier)"
                    var request = URLRequest(url: remotefile)
                    request.httpMethod  = "POST"
                    request.httpBody    = postdata.data(using: String.Encoding.utf8)
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            Logger.AllowRemoteLog = false
                            Logger.error(format: "Remote returned an error - disabling remote-logging")
                            Logger.error(error: error)
                        } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                            Logger.AllowRemoteLog = false
                            Logger.error(format: "Remote returned non-OK-staus - disabling remote-logging")
                        }
                    }
                    task.resume()
                }
            }
        }
    }

    /**
        Parse a Date-Object to a String

        - parameter date: The Date-Object to be parsed

        - returns: The String-Representation of date in format yyyy-MM-dd HH:mm:ss.SSS
    */
    private static func parseAccurateDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

        return formatter.string(from: date as Date)
    }
}
