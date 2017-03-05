//
//  Logger.swift
//  Showroom
//
//  Created by Alexander Weleczka on 03.03.17.
//  Copyright © 2017 AWeleczka.de - All rights reserved.
//

import Foundation

class Logger: NSObject {
    internal enum LogLevel: String {
        case Trace      = "TRC"
        case Debug      = "DBG"
        case Info       = "INF"
        case Warning    = "WRN"
        case Error      = "ERR"
    }

    /// Allow logging to XCode-Console
    public static var AllowConsoleLog: Bool                = true
    /// Restrict console-output to these LogLevels
    public static var ConsoleLogLevels: [Logger.LogLevel]  = [.Trace, .Debug, .Info, .Warning, .Error]

    /// Allow logging to logfile
    public static var AllowLocalLog: Bool                  = true
    /// Restrict logfile-output to these LogLevels
    public static var LocalLogLevels: [Logger.LogLevel]    = [.Info, .Warning, .Error]
    /// Name of the logfile in the application directory
    public static var LocalLogFile: String                 = "application.log"

    /// Allow logging to Remote-Script
    public static var AllowRemoteLog: Bool                 = true
    /// Restrict remote-output to these LogLevels
    public static var RemoteLogLevels: [Logger.LogLevel]   = [.Warning, .Error]
    /// URL of the Remote-Script
    public static var RemoteLogURL: String                 = ""
    /// Identifyer-String of this session
    public static var RemoteIdentifier: String             = ""

    /// Initialize Logger-Settings directly
    /// - parameter allowconsolelog: Allow logging to XCode-Console
    /// - parameter consoleloglevels: Restrict console-output to these LogLevels
    /// - parameter allowlocallog: Allow logging to logfile
    /// - parameter localloglevels: Restrict logfile-output to these LogLevels
    /// - parameter locallogfile: Name of the logfile in the application directory
    /// - parameter allowremotelog: Allow logging to Remote-Script
    /// - parameter remoteloglevels: Restrict remote-output to these LogLevels
    /// - parameter remotelogurl: URL of the Remote-Script
    /// - parameter remoteidentifyer: Identifyer-String of this session
    init(allowconsolelog: Bool = true, consoleloglevels: [Logger.LogLevel] = [.Trace, .Debug, .Info, .Warning, .Error], allowlocallog: Bool = true, localloglevels: [Logger.LogLevel] = [.Info, .Warning, .Error], locallogfile: String = "Application.log", allowremotelog: Bool = false, remoteloglevels: [Logger.LogLevel] = [.Warning, .Error], remotelogurl: String = "", remoteidentifier: String = "") {
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

    /// Log Function-Access as TRACE
    /// - parameter file: Do not declare - passing the file-name along
    /// - parameter line: Do not declare - passing the line-number along
    /// - parameter column: Do not declare - passing the column-number along
    /// - parameter function: Do not declare - passing the function-name along
    public static func access(_ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = "Accessed function \"\(function)\""
        let timestamp   = NSDate()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(loglevel: Logger.LogLevel.Trace, timestamp: timestamp, message: message, position: position)
        Logger.localline(loglevel: Logger.LogLevel.Trace, timestamp: timestamp, message: message, position: position)
        Logger.remoteline(loglevel: Logger.LogLevel.Trace, timestamp: timestamp, message: message, position: position)
    }

    /// Log Memory-Warning as WARNING
    /// - parameter file: Do not declare - passing the file-name along
    /// - parameter line: Do not declare - passing the line-number along
    /// - parameter column: Do not declare - passing the column-number along
    /// - parameter function: Do not declare - passing the function-name along
    public static func memory(_ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = "\"\(file.components(separatedBy: "/").last ?? "")\" received a memory-warning"
        let timestamp   = NSDate()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(loglevel: Logger.LogLevel.Warning, timestamp: timestamp, message: message, position: position)
        Logger.localline(loglevel: Logger.LogLevel.Warning, timestamp: timestamp, message: message, position: position)
        Logger.remoteline(loglevel: Logger.LogLevel.Warning, timestamp: timestamp, message: message, position: position)
    }

    /// Log a message as TRACE
    /// - parameter format: Format or String of the message
    /// - parameter args: Args used in format
    /// - parameter file: Do not declare - passing the file-name along
    /// - parameter line: Do not declare - passing the line-number along
    /// - parameter column: Do not declare - passing the column-number along
    /// - parameter function: Do not declare - passing the function-name along
    public static func trace(format: String, _ args: CVarArg..., _ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = String(format: format, args)
        let timestamp   = NSDate()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(loglevel: Logger.LogLevel.Trace, timestamp: timestamp, message: message, position: position)
        Logger.localline(loglevel: Logger.LogLevel.Trace, timestamp: timestamp, message: message, position: position)
        Logger.remoteline(loglevel: Logger.LogLevel.Trace, timestamp: timestamp, message: message, position: position)
    }

    /// Log a message as DEBUG
    /// - parameter format: Format or String of the message
    /// - parameter args: Args used in format
    /// - parameter file: Do not declare - passing the file-name along
    /// - parameter line: Do not declare - passing the line-number along
    /// - parameter column: Do not declare - passing the column-number along
    /// - parameter function: Do not declare - passing the function-name along
    public static func debug(format: String, _ args: CVarArg..., _ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = String(format: format, args)
        let timestamp   = NSDate()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(loglevel: Logger.LogLevel.Debug, timestamp: timestamp, message: message, position: position)
        Logger.localline(loglevel: Logger.LogLevel.Debug, timestamp: timestamp, message: message, position: position)
        Logger.remoteline(loglevel: Logger.LogLevel.Debug, timestamp: timestamp, message: message, position: position)
    }

    /// Log a message as INFO
    /// - parameter format: Format or String of the message
    /// - parameter args: Args used in format
    /// - parameter file: Do not declare - passing the file-name along
    /// - parameter line: Do not declare - passing the line-number along
    /// - parameter column: Do not declare - passing the column-number along
    /// - parameter function: Do not declare - passing the function-name along
    public static func info(format: String, _ args: CVarArg..., _ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = String(format: format, args)
        let timestamp   = NSDate()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(loglevel: Logger.LogLevel.Info, timestamp: timestamp, message: message, position: position)
        Logger.localline(loglevel: Logger.LogLevel.Info, timestamp: timestamp, message: message, position: position)
        Logger.remoteline(loglevel: Logger.LogLevel.Info, timestamp: timestamp, message: message, position: position)
    }

    /// Log a message as WARNING
    /// - parameter format: Format or String of the message
    /// - parameter args: Args used in format
    /// - parameter file: Do not declare - passing the file-name along
    /// - parameter line: Do not declare - passing the line-number along
    /// - parameter column: Do not declare - passing the column-number along
    /// - parameter function: Do not declare - passing the function-name along
    public static func warning(format: String, _ args: CVarArg..., _ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = String(format: format, args)
        let timestamp   = NSDate()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(loglevel: Logger.LogLevel.Warning, timestamp: timestamp, message: message, position: position)
        Logger.localline(loglevel: Logger.LogLevel.Warning, timestamp: timestamp, message: message, position: position)
        Logger.remoteline(loglevel: Logger.LogLevel.Warning, timestamp: timestamp, message: message, position: position)
    }

    /// Log a message as ERROR
    /// - parameter format: Format or String of the message
    /// - parameter args: Args used in format
    /// - parameter file: Do not declare - passing the file-name along
    /// - parameter line: Do not declare - passing the line-number along
    /// - parameter column: Do not declare - passing the column-number along
    /// - parameter function: Do not declare - passing the function-name along
    public static func error(format: String, _ args: CVarArg..., _ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = String(format: format, args)
        let timestamp   = NSDate()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(loglevel: Logger.LogLevel.Error, timestamp: timestamp, message: message, position: position)
        Logger.localline(loglevel: Logger.LogLevel.Error, timestamp: timestamp, message: message, position: position)
        Logger.remoteline(loglevel: Logger.LogLevel.Error, timestamp: timestamp, message: message, position: position)
    }

    /// Log an error as ERROR
    /// - parameter error: The NSError-Object
    /// - parameter file: Do not declare - passing the file-name along
    /// - parameter line: Do not declare - passing the line-number along
    /// - parameter column: Do not declare - passing the column-number along
    /// - parameter function: Do not declare - passing the function-name along
    public static func error(error: Error, _ file: String = #file, _ line: Int = #line, _ column: Int = #column, _ function: String = #function) {
        let message     = "Error# \(error._code) occured \"\(error.localizedDescription)\""
        let timestamp   = NSDate()
        let position    = String(format: "%@[%d]", file.components(separatedBy: "/").last ?? "", line)

        Logger.consoleline(loglevel: Logger.LogLevel.Error, timestamp: timestamp, message: message, position: position)
        Logger.localline(loglevel: Logger.LogLevel.Error, timestamp: timestamp, message: message, position: position)
        Logger.remoteline(loglevel: Logger.LogLevel.Error, timestamp: timestamp, message: message, position: position)
    }

    // MARK: - Housekeeping

    /// Return and delete local log
    /// - returns: The current logfile-content before deletion
    public static func flushLocalLog() -> String {
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

    /// Remove local logfile
    public static func deleteLocalLog() {
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

    /// Log data to XCode-Console
    /// - parameter loglevel: Loge-Level of log-call
    /// - parameter timestamp: Synchronized timestamp of log-call
    /// - parameter message: Pre-Parsed log-message
    /// - parameter position: Pre-Parsed in-code-position of log-call
    private static func consoleline(loglevel: Logger.LogLevel, timestamp: NSDate, message: String, position: String) {
        if Logger.AllowConsoleLog && Logger.ConsoleLogLevels.contains(loglevel) {
            DispatchQueue(label: "Logger.consoleline").async {
                Swift.print(">> \(Logger.parseAccurateDate(date: timestamp)) > \(loglevel.rawValue) @ \(position) : \(message)")
            }
        }
    }

    /// Log data to local file
    /// - parameter loglevel: Loge-Level of log-call
    /// - parameter timestamp: Synchronized timestamp of log-call
    /// - parameter message: Pre-Parsed log-message
    /// - parameter position: Pre-Parsed in-code-position of log-call
    private static func localline(loglevel: Logger.LogLevel, timestamp: NSDate, message: String, position: String) {
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
                    } catch let e as NSError {
                        Logger.AllowLocalLog = false
                        Logger.error(format: "Unable to log to local file - disabling local-logging")
                        Logger.error(error: e)
                    }

                }
            }
        }
    }

    /// Log data to remote API
    /// - parameter loglevel: Loge-Level of log-call
    /// - parameter timestamp: Synchronized timestamp of log-call
    /// - parameter message: Pre-Parsed log-message
    /// - parameter position: Pre-Parsed in-code-position of log-call
    private static func remoteline(loglevel: Logger.LogLevel, timestamp: NSDate, message: String, position: String) {
        if Logger.AllowRemoteLog && Logger.RemoteLogLevels.contains(loglevel) {
            if let remotefile: URL = URL(string: Logger.RemoteLogURL) {
                DispatchQueue(label: "Logger.remoteline").async {
                    let postdata = "loglevel=\(loglevel.rawValue)&timestamp=\(Logger.parseAccurateDate(date: timestamp))&message=\(message)&position=\(position)&identifier=\(Logger.RemoteIdentifier)"
                    var request = URLRequest(url: remotefile)
                    request.httpMethod  = "POST"
                    request.httpBody    = postdata.data(using: String.Encoding.utf8)
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error as? NSError {
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

    private static func parseAccurateDate(date: NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

        return formatter.string(from: date as Date)
    }
}
