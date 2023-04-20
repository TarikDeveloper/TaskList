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

struct ContentView: View {
    @ObservedObject var taskList = TaskList()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Nova Tarefa", text: $taskList.newTask)
                        .padding(.horizontal)
                    Button(action: {
                        taskList.addTask()
                    }) {
                        Image(systemName: "plus")
                    }.padding(.horizontal)
                }
                .frame(height: 40)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)
                .padding(.horizontal)
                
                List {
                    ForEach(taskList.tasks) { task in
                        TaskRow(taskList: taskList, task: task)
                    }
                    .onDelete(perform: taskList.removeCompletedTasks)
                }
                
                Button(action: {
                    taskList.removeCompletedTasks(atOffsets: IndexSet(taskList.tasks.indices.filter { taskList.tasks[$0].isCompleted }))
                }) {
                    Text("Excluir Tarefas Concluídas")
                }
                .padding(.top)
                .foregroundColor(.red)
                
            }
            .navigationBarTitle("Minhas Tarefas")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
