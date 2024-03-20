//
//  Test1View.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 3/20/24.
//

import Foundation
//
//  TestView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 3/20/24.
//

import Foundation
import SwiftUI

// 트리의 노드를 나타내는 구조체 정의
class TreeNode: Identifiable {
    let id = UUID()
    var value: Int
    var children: [TreeNode]
    
    init(value: Int, children: [TreeNode] = []) {
        self.value = value
        self.children = children
    }
}


// 트리의 각 노드를 표시하는 SwiftUI 뷰 정의
struct TreeNodeView: View {
    let node: TreeNode
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 40, height: 40)
                .overlay(
                    Text("\(node.value)")
                        .foregroundColor(.white)
                        .font(.headline)
                )
            HStack(alignment: .top){
                ForEach(node.children) { child in
                    VStack{
                        Image(systemName: "chevron.down")
                            .padding(.bottom)
                        TreeNodeView(node: child)
                    }
                }
            }.padding()
        }
    }
}

// 이진 트리의 루트 노드를 사용하여 트리 뷰를 생성하는 SwiftUI 뷰 정의
struct TreeView: View {
    let root: TreeNode
    
    var body: some View {
        VStack {
            TreeNodeView(node: root)
        }
    }
}

// ContentView에 트리 뷰 추가
struct Test1View: View {
    let treeRoot: TreeNode
        
        var body: some View {
            TreeNodeView(node: treeRoot)
        }
}

// ContentView를 미리보기
struct Test1View_Previews: PreviewProvider {
    static var previews: some View {
            let node10 = TreeNode(value: 10)
            let node4 = TreeNode(value: 4)
            let node5 = TreeNode(value: 5)
            let node6 = TreeNode(value: 6)
            let node7 = TreeNode(value: 7,children: [node10])
            let node2 = TreeNode(value: 2, children: [node4, node5,node6])
            let node3 = TreeNode(value: 3, children: [node7])
            let treeRoot = TreeNode(value: 1, children: [node2, node3])
            return Test1View(treeRoot: treeRoot)
        }
}
