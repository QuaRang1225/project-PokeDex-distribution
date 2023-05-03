
import SwiftUI

struct ContentView:View{
    @State var start = false
    var body: some View{
        ZStack{
            if start{
                MainView()
            }else{
                StartView()
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 1.0)){
                    start = true
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
