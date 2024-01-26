//
//  Task.swift
//  NotesApp
//
//  Created by Альпеша on 26.01.2024.
//

import SwiftUI
import Foundation

struct Task: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
