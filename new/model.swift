//
//  model.swift
//  text
//
//  Created by imac 1682's MacBook Pro on 2024/8/7.
//

import RealmSwift
import Foundation


class dog: Object {
    @Persisted var numbers: Int = 0
    @Persisted var name: String = ""
    @Persisted var say: String = ""
    @Persisted var time: Date
    
    convenience init(numbers:Int,name: String, say: String,time:Date) {
          self.init()
          self.name = name
          self.say = say
          self.time = time
          self.numbers = numbers
      }
}
