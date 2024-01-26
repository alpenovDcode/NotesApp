//
//  TaskViewModel.swift
//  NotesApp
//
//  Created by Альпеша on 26.01.2024.
//

import SwiftUI
import Combine

class TaskViewModel: ObservableObject {
    @Published var storedTasks: [Task] = []
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()
    @Published var filteredTasks: [Task]? = []
    private var cancellables: Set<AnyCancellable> = []

    init() {
        fetchCurrentWeek()
        $storedTasks
                   .sink { [weak self] _ in
                       self?.filterTodayTasks()
                   }
                   .store(in: &cancellables)
    }

    func filterTodayTasks() {
        let calendar = Calendar.current
        let filtered = storedTasks.filter {
            return calendar.isDate($0.taskDate, inSameDayAs: currentDay)
        }
        filteredTasks = filtered
    }

    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)

        guard let firstWeekDay = week?.start else {
            return
        }
        (0..<7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }

    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }

    func addTask(task: Task) {
        storedTasks.append(task)
        filterTodayTasks()
    }
}
