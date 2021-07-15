import UIKit
import RxSwift

//startWith(:_)
let bag = DisposeBag()
Observable
    .of("B", "C", "D", "E")
    .startWith("A")
    .subscribe(onNext: {value in
        print(value)
    })
    .disposed(by: bag)
print("---------------")

//Observable.concat
let first = Observable.of(1 ,2 ,3)
let second = Observable.of(4 ,5 ,6)
let observable = Observable.concat([first, second])
observable.subscribe(onNext: {value in
    print(value)
}).disposed(by: bag)

print("---------------")

//concat
let third = Observable.of("A", "B", "C")
let fourth = Observable.of("D", "E", "F")
let observable2 = third.concat(fourth)
observable2.subscribe(onNext: {value in
    print(value)
}).disposed(by: bag)
print("---------------")

//concatMap
let cities = [ "Mien Bac" : Observable.of("Ha Noi", "Hai Phong"),
               "Mien Trung" : Observable.of("Hue", "Da Nang"),
               "Mien Nam" : Observable.of("Ho Chi Minh", "Can Tho")]
let observable3 = Observable
    .of("Mien Bac", "Mien Trung", "Mien Nam")
    .concatMap{name in
        cities[name] ?? .empty()
    }

observable3.subscribe(onNext: { value in
    print(value)
}).disposed(by: bag)

print("---------------")
print("---------------")
print("---------------")

//Merge

let chu = PublishSubject<String>()
let so = PublishSubject<String>()

let source = Observable.of(chu.asObserver(), so.asObserver())
let observable4 = source.merge()
observable4.subscribe(onNext: {value in
    print(value)
}).disposed(by: bag)

chu.onNext("Một")
so.onNext("1")
chu.onNext("Hai")
so.onNext("2")
chu.onNext("Ba")
so.onCompleted()
so.onNext("3")
chu.onNext("Bốn")
chu.onCompleted()
print("---------------")
print("---------------")
print("---------------")

//Combining elements
//combineLatest

let word = PublishSubject<String>()
let number = PublishSubject<String>()
let observable5 = Observable.combineLatest(word, number){
    word, number in
    "\(word) : \(number)"
}

observable5
    .subscribe(onNext: { (value) in
        print(value)
    })
.disposed(by: bag)
word.onNext("Một")
word.onNext("Hai")
number.onNext("1")
number.onNext("2")
word.onNext("Ba")
number.onNext("3")
//completed
word.onCompleted()
word.onNext("Bốn")
number.onNext("4")
number.onNext("5")
number.onNext("6")
//completed
number.onCompleted()

print("---------------")

//combineLatest(_:_:resultSelector:)
let choice : Observable<DateFormatter.Style> = Observable
    .of(.short, .long)
let date = Observable.of(Date())
let observable6 = Observable
    .combineLatest(choice, date){ format, when ->String in
    let formatter = DateFormatter()
    formatter.dateStyle = format
    return formatter.string(from: when)
}

_ = observable6.subscribe(onNext:{ value in
    print(value)
}).disposed(by: bag)
print("---------------")

//zip
let word1 = PublishSubject<String>()
let number1 = PublishSubject<String>()
let observable7 = Observable.zip(word1, number1) { word1, number1 in
        "\(word1) : \(number1)"
    }
observable7
    .subscribe(onNext: { (value) in
        print(value)
    })
.disposed(by: bag)
word1.onNext("Một")
word1.onNext("Hai")
number1.onNext("1")
number1.onNext("2")
word1.onNext("Ba")
number1.onNext("3")
//completed
word1.onNext("Bốn")
number1.onNext("4")
number1.onNext("5")
number1.onNext("6")
word1.onNext("Sáu")
word1.onNext("Năm")

//completed
word1.onCompleted()
number1.onCompleted()

print("---------------")
print("---------------")
print("---------------")

//Trigger
//withLatestFrom
