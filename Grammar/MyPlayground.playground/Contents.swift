var arr = [String]()
arr.append("a")
arr.append(contentsOf: ["b","c","d"])
arr.insert("f", at:2)
for alphabet in arr{
    var index = arr.index(of: alphabet)
    print("\(alphabet)의 인덱스는 \(index!)임")
}

var sett : Set = ["A","B","C","D"]
sett.insert("E")
sett.remove("A")

for alpha in sett {
    print("\(alpha)")
}

let odds : Set = [1,3,5,7,9]
let even : Set = [2,4,6,8,10]
let prime : Set = [2,3,5,7]

odds.intersection(prime)
odds.symmetricDifference(even)

let tuple1 = ("a","b",1,5,true)
tuple1.2
var tpl101 : (Int,(String, String))
// 타입 어노테이션 가능.

let (a,b,c,d,e) = tuple1
a
b

var dict = [String : String]()
dict["d"] = "D"
dict
dict["d"] = "A"
dict
dict.updateValue("c", forKey: "c")
dict["d"] = nil
dict.removeValue(forKey: "c")
dict

var optInt: Int?
optInt = 3
print(optInt!)

var str = "Swift"
if let intFromStr = Int(str) {
    print("값 변환 완료. \(intFromStr)")
    }
else {
    print("값 변환 실패")
}

