
import SwiftUI
import RealmSwift

struct ContentView:View{
    @StateObject var vm = PokeDexViewModel()
    @StateObject var vmSave = SaveViewModel()
    @State var start = false
    var body: some View{
        ZStack{
            if start{
//                MainView().environmentObject(vm)
                MenuTabView()
                    .environmentObject(vm)
                    .environmentObject(vmSave)
            }else{
                StartView().environmentObject(vm)
            }
        }.onAppear{
            if vm.pokeDexCount != 1010{
                PokeDex.deleteAll()
                vm.get()
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeInOut(duration: 1.0)){
                        start = true
                    }
                }
            }
            print(Realm.Configuration.defaultConfiguration.fileURL!)
        }
        .onChange(of: vm.successDownload){ newValue in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 1.0)){
                    start = newValue
//                    UserDefaults.standard.set(true, forKey: "ver 1.0.0")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
