
import SwiftUI
import RealmSwift

struct ContentView:View{
//    @StateObject var vm = PokeDexViewModel()
//    @StateObject var vmSave = SaveViewModel()
    @State var start = false
    
    var body: some View{
        ZStack{
            if start{
//                    MainView()
//                        .environmentObject(vm)
//                        .environmentObject(vmSave)
                
            }else{
//                StartView().environmentObject(vm)
            }
        }.onAppear{
            
//            print(Realm.Configuration.defaultConfiguration.fileURL!)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                withAnimation(.easeInOut(duration: 1.0)){
//                    start = true
//                }
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension ContentView{
    var ok:some View{
        Button{
            
        } label: {
            
        }
    }
    var dismiss:some View{
        Button {
            
        } label: {
            
        }
    }
}
