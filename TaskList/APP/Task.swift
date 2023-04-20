//  Created by Tarik Villalobos on 20/04/23.
//
//  MARK: Social Media
//  Instagram: tarik.developer
//  GitHub: TarikDeveloper
//  Gmail: tarik.developer1@gmail.com

import SwiftUI

struct Task: Identifiable {
    var id = UUID()
    var name: String
    var isCompleted: Bool
}

class TaskList: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var newTask = ""
    
    func addTask() {
        tasks.append(Task(name: newTask, isCompleted: false))
        newTask = ""
    }
    
    func toggleTask(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func removeCompletedTasks(atOffsets offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

struct TaskRow: View {
    @ObservedObject var taskList: TaskList
    var task: Task
    
    var body: some View {
        HStack {
            Text(task.name)
                .strikethrough(task.isCompleted)
            Spacer()
            if task.isCompleted {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .onTapGesture {
                        if let index = taskList.tasks.firstIndex(where: { $0.id == task.id }) {
                            taskList.tasks.remove(at: index)
                        }
                    }
            } else {
                Button(action: {
                    taskList.toggleTask(task: task)
                }) {
                    Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                }
            }
        }
    }
}
