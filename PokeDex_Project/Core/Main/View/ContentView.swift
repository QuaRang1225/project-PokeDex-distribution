
import SwiftUI
import RealmSwift

struct ContentView:View{
    @StateObject var vm = PokeDexViewModel()
    @StateObject var vmSave = SaveViewModel()
    @State var start = false
    @State var downloadStart = false
    @State var dowlnLoadAccess = false
    
    var body: some View{
        ZStack{
            if start{
                if downloadStart{
                    MainView()
                        .environmentObject(vm)
                        .environmentObject(vmSave)
                }else{
                    CircleProgressView()
                        .environmentObject(vm)
                        .onAppear{
                            if vm.pokeDexCount != 1025{
                                PokeDex.deleteAll()
                                vm.get()
                            }
                        }
                }
            }else{
                StartView().environmentObject(vm)
            }
        }.onAppear{
            
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 1.0)){
                    if vm.pokeDexCount == 1025{
                        downloadStart = true
                        start = true
                        
                    }else{
                        dowlnLoadAccess = true
                    }
                    
                }
            }
            
            
        }
        .onChange(of: vm.successDownload){ newValue in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 1.0)){
                    downloadStart = newValue
                }
            }
        }
        .alert(isPresented: $dowlnLoadAccess) {
            
            Alert(title: Text("알림"),message: Text("포켓몬 1010마리의 도감 리소스 정보(약 524KB)를 다운로드 해야합니다.\n 다운로드 하시겠습니까?"), primaryButton: .default(Text("예"),action: {
                start = true
            }), secondaryButton: .cancel(Text("아니오"),action: {
                exit(0)
            }))
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
