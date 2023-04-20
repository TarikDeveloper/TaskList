//  Created by Tarik Villalobos on 20/04/23.
//
//  MARK: Social Media
//  Instagram: tarik.developer
//  GitHub: TarikDeveloper
//  Gmail: tarik.developer1@gmail.com

import SwiftUI

struct ContentView: View {
    @ObservedObject var taskList = TaskList()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("My Tasks", text: $taskList.newTask)
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
                    Text("Delete Completed Tasks")
                }
                .padding(.top)
                .foregroundColor(.red)
                
            }
            .navigationBarTitle("My Tasks")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
