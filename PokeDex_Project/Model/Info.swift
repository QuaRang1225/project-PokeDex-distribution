//
//  Info.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/07/15.
//

import Foundation

struct Info{
    
    var dexNum:Int  //도감번호
    var image:String //이미지
    var name:String  //이름
    var genera:String   //타이틀
    var height:Int  //키
    var weight:Int   //몸무게
    var eggGroup:[String]    //알그룹
    var gender:[Double] //성비
    var get:Int  //포획률
    
    var firstChar:String   //특성
    var firstCharDesc:String    //특성 설명
    var secondChar:String   //특성
    var secondCharDesc:String    //특성 설명
    var hiddenChar:String  //숨겨진 특성
    var hiddenCharDesc:String //숨겨진특성 설명
    
    var types:[String]   //타입
    
    //스탯
    var hp:[Int]
    var attack:[Int]
    var defense:[Int]
    var spAttack:[Int]
    var spDefense:[Int]
    var speed :[Int]
    var avr :[Int]
    
    //진화트리 - 포켓몬 이미지
    var first :[String]
    var second :[String]
    var third :[String]
    
    //진화트리 - 포켓몬 이름
    var firstName :[String]
    var secondName :[String]
    var thirdName :[String]
    
    var desc :[String]    //도감설명
    
    var isRegion :[Int]
    var isRegionName:[String]
    
    var isForm:[String]
    var isFormname:[String]
    
    var mega:[String]
}
