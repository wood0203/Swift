import UIKit

// 7.함수
func printHello() {
    print("안녕하세요")
}

// 함수는 void형, 반환값이 없는경우도 가능함.
func sayHElloWithName(name: String) -> String {
    let returnvalue = "\(name)님 안녕하세요"
    return returnvalue
}

func add(x: Int, y: Int) -> Int {
    let answer = x + y
    return answer
}

print(sayHElloWithName(name: "이인우"))
print(add(x: 3, y: 5)) // 라벨링은 필수!!


// 7.1 튜플 반환 함수
func getUserInfo() -> (Int, Character, String) {
    let gender: Character = "M"
    let height = 180
    let name = "이인우"
    
    return (height, gender, name)
}

var uInfo = getUserInfo()
print(uInfo.0)
print(uInfo.2) // 튜플형을 return으로 받으면 인덱싱해서 접근 가능

var (a,b,c) = getUserInfo()
a
b // 변수에 저장도 가능, 튜플 길이와 똑같아야함.

// 타입 알리어스
// 반환형을 미리 입력시키는 변수 -> 코드 축약 가능.
typealias infoResult = (Int, Character, String)
func getuserInfo() -> infoResult {
    let gender: Character = "M"
    let height = 180
    let name = "이인우"
    return (height, gender, name)
}

let info = getuserInfo()
info.2

// 7.2 외부&내부 매개변수
func printHello(to name: String, welcomeMessage msg: String) {
    print("\(name)님, \(msg)")
}
print(printHello(to:"이인우", welcomeMessage: "안녕하세요"))
// to와 welcomeMEssage는 함수 외부에서 호출할때 입력값.
// name, msg는 함수 내부에서 호출할때 입력값.

// 외부 매개변수 생략. 일부만 생략도 가능
func sayHello(_ name: String, _ msg: String) {
    print("\(name)님 \(msg)")
}
print(sayHello("홍길동", "안녕하세요"))

// 7.3 가변 인자
// 인자값이 여러개일 때는 ...을 붙여 배열을 입력값으로 받음.
// 디폴트값도 = ? 방식으로 입력 가능.
func avg(score: Int...) -> Double {
    var total = 0
    for  r in score {
        total += r
    }
    return (Double(total) / Double(score.count))
}
print(avg(score: 10,20,30,40))
// 입력값을 굳이 리스트로 입력하지않고 함수형태로 입력.


// 7.4 매개변수 주의점
func incrementBy(base: Int) -> Int {
    // base += 1
    // 입력인자는 let 상수형을 바뀌기 때문에 값을 수정을 못함.
    var base = base
    // var 변수로 입력값을 받아서 대입해줘야 수정 가능.
    base += 1
    return base
}

// Inout 매개변수
// 입력변수의 메모리를 직접 전달해서 입력변수가
// 함수 실행 후에도 값이 그대로 저장됨. (포인터 개념)
var t = 100
func foo(param: inout Int) -> Int {
    param += 1
    return param
}
print(foo(param: &t))
print(t)

//let a = 100 x
//print(foo(param: &a))
//inout 함수에서 입력변수는 무조건 var 형식. 리터럴 x


//7.5 일급함수
//조건 1 변수나 상수에 함수 대입이 가능.
func foo1(base: Int) -> String {
    print("함수 실행중")
    return "결과값은 \(base)입니다."
}
let fn3 = foo1(base: 5)
let fn4 = foo1 // 현재 변수의 타입은 함수 타입.
fn4(7)

let fn: (Int) -> String = foo1
let fn1 = foo1(base:) // 함수 선언할때 식별자까지 선언하는게 좋음.
fn1(3) //파라미터 라벨링 따로 안해줘도됨.
fn(3)

//조건 2 함수의 반환타입으로 함수를 사용할 수 있음.
func desc() -> String {
    return "this is desc()"
}

func pass() -> () -> String {
    return desc
}
// pass() 함수는 desc 함수를 반환하므로
// pass -> {() -> String}(= desc)
let p = pass()
p()

//조건 3 함수의 인자값으로 함수를 사용할 수 있음.
func incr(param: Int) -> Int {
    return param + 1
}

func broker(base: Int, function fn: (Int) -> Int) -> Int {
    return fn(base)
}

broker(base:3, function: incr)
let cn = broker
cn(3,incr)

func successThrough() {
    print("연산 처리가 성공했습니다.")
}

func failThrough() {
    print("처리 과정에 오류가 발생함.")
}

func divide(base: Int, success sCallBack:() -> Void, fail fCallBack:() -> Void) -> Int {
    guard base != 0 else {
        fCallBack()
        return 0
    }
    
    defer {
        sCallBack()
    }
    return 100/base
}

divide(base:30, success: successThrough, fail: failThrough)
