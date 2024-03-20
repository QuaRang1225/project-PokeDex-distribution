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
    var left: TreeNode?
    var right: TreeNode?
    
    init(value: Int, left: TreeNode? = nil, right: TreeNode? = nil) {
        self.value = value
        self.left = left
        self.right = right
    }
}

// 이진 트리를 생성하는 함수 정의
func createBinaryTree() -> TreeNode {
    let node7 = TreeNode(value: 7)
    let node6 = TreeNode(value: 6)
    let node5 = TreeNode(value: 5)
    let node4 = TreeNode(value: 4)
    let node3 = TreeNode(value: 3, left: node6, right: node7)
    let node2 = TreeNode(value: 2, left: node4, right: node5)
    let root = TreeNode(value: 1, left: node2, right: node3)
    return root
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
            HStack {
                if let left = node.left {
                    TreeNodeView(node: left)
                }
                Spacer()
                if let right = node.right {
                    TreeNodeView(node: right)
                }
            }
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
    let treeRoot = createBinaryTree()
    
    var body: some View {
        TreeView(root: treeRoot)
    }
}

// ContentView를 미리보기
struct Test1View_Previews: PreviewProvider {
    static var previews: some View {
        Test1View()
    }
}
