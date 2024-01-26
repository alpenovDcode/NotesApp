//
//  AddTaskView.swift
//  NotesApp
//
//  Created by Альпеша on 26.01.2024.
//

import SwiftUI

struct AddTaskView: View {
    @Binding var isAddingTask: Bool
    @EnvironmentObject var taskModel: TaskViewModel
    @State private var taskTitle = ""
    @State private var taskDescription = ""
    @State private var taskDate = Date()
    var body: some View {
        VStack {
            Text("Новая задача")
                .font(.title)
                .padding()

            TextField("Заголовок", text: $taskTitle)
                .textFieldStyle(.roundedBorder)
                .padding()

            TextField("Описание", text: $taskDescription)
                .textFieldStyle(.roundedBorder)
                .padding()

            DatePicker("Дата", selection: $taskDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()

            Button(action: {
                // Добавление новой задачи в модель данных
                let newTask = Task(taskTitle: taskTitle, taskDescription: taskDescription, taskDate: taskDate)
                taskModel.storedTasks.append(newTask)

                isAddingTask = false
            }) {
                Text("Добавить")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()

            Button(action: {
                isAddingTask = false
            }) {
                Text("Отмена")
                    .font(.title2)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding()
        .shadow(radius: 5)
    }
}
