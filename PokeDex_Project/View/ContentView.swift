
import SwiftUI
import RealmSwift

struct ContentView:View{
    @State var start = false
    
    var body: some View{
        ZStack{
            if start{
                MainView()
            }else{
                StartView()
            }
        }.onAppear{
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 1.0)){
                    start = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
