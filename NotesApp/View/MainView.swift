//
//  MainView.swift
//  NotesApp
//
//  Created by Альпеша on 26.01.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    @State private var isAddingTask = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(taskModel.currentWeek, id: \.self) { day in
                                VStack(spacing: 10) {
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                    Capsule()
                                        .fill(.black)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .secondary)
                                .foregroundColor(taskModel.isToday(date: day) ? .black : .white)
                                .frame(width: 45, height: 90)
                                .background(
                                    ZStack {
                                        if taskModel.isToday(date: day) {
                                            Capsule()
                                                .fill(.white)
                                                .matchedGeometryEffect(id: "CURRENTDAT", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation {
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    TasksView()
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .sheet(isPresented: $isAddingTask) {
            AddTaskView(isAddingTask: $isAddingTask)
                .environmentObject(taskModel)
        }
    }
    
    func TasksView() -> some View {
        LazyVStack(spacing: 18) {
            if let tasks = taskModel.filteredTasks {
                if tasks.isEmpty {
                    Text("No tasks Found!!!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                } else {
                    ForEach(tasks) { task in
                        TaskCardView(task: task)
                    }
                }
            } else {
                ProgressView()
                    .offset(y: 100)
            }
            
            Button(action: {
                isAddingTask = true
            }) {
                Label("Добавить задачу", systemImage: "plus.circle")
                    .font(.title2)
            }
            .padding()
        }
        .padding()
        .padding(.top)
        .onChange(of: taskModel.currentDay) { _, _ in
            taskModel.filterTodayTasks()
        }
    }
    
    func TaskCardView(task: Task)->some View{
        HStack(alignment: .top, spacing: 30){
            VStack{
                Circle()
                    .fill(.white)
                    .frame(width: 15, height: 15)
                    .background(
                        
                        Circle()
                            .stroke(.white, lineWidth: 1)
                            .padding(-3)
                    )
                Rectangle()
                    .fill(.white)
                    .frame(width: 3)
            }
            VStack {
                HStack(alignment: .top, spacing: 10){
                    VStack(alignment: .leading, spacing: 12){
                        Text(task.taskTitle)
                            .font(.title2.bold())
                        
                        Text(task.taskDescription)
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    .hLeading()
                    
                }
            }
            
            .padding()
            .hLeading()
            .background(
                
                Color("Color")
                    .cornerRadius(25)
            )
            
        }
        .hLeading()
    }
    
    func HeaderView()->some View{
        
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text("Today")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipShape(Circle())
        }
        .padding(.top)
        .padding()
        .background(.black)
    }
}

extension View{
    
    func hLeading()->some View{
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing()->some View{
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter()->some View{
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    func getSafeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        return safeArea
    }
}
