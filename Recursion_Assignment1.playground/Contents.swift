import Foundation

// reference
// https://dai1741.github.io/maximum-algo-2012/docs/parsing/
// https://qiita.com/7shi/items/64261a67081d49f941e3



// Homework
// 3. printBinary(n): prints binary form of given int
func printBinary(_ n: Int) {
    // base case
    return printBinaryHelper(n, "")
}

func printBinaryHelper(_ n: Int, _ res: String) {
    var resUpdated = res
    if n <= 1 {
        resUpdated = String(n) + resUpdated
        print(resUpdated)
        return
    }
    resUpdated = String(n%2) + resUpdated
    printBinaryHelper(n/2, resUpdated)
}

printBinary(50)
printBinary(0)



// Homework
// 4. reverseLines
// - Print all lines in reverse order (recursively) from a text file
// - You can change the function header if you want
func reverseLines() -> String? {
    //  let contents = try! String(contentsOfFile: "/Users/park/Desktop/SwiftAGDS/SwiftAGDS/Recursion/story.txt")
    guard let fileUrl = Bundle.main.url(forResource: "story", withExtension: "txt") else {
        return nil
    }
    guard let contents = try? String(contentsOf: fileUrl, encoding: .utf8) else {
        return nil
    }
    
    return reverseLinesHelper(contents, "")
}

func reverseLinesHelper(_ content: String, _ res: String) -> String {
    if let lineChangeIndex = content.firstIndex(of: "\n") {
        let indexNextToLineChange = content.index(after: lineChangeIndex)
        if content.count != 0 {
            let newContent = content[indexNextToLineChange...]
            let currLine = content[...lineChangeIndex]
            return reverseLinesHelper(String(newContent), currLine + res)
        }
    }
    return res
}

print(reverseLines()!)



/// 5. evaluate
/// Write a recursive function evaluate that accepts a string representing a math expression and computes its value.
/// - The expression will be "fully parenthesized" and will consist of + and * on single-digit integers only.
/// - You can use a helper function. (Do not change the original function header)
/// - Use Recursion
/// evaluate("7")                 -> 7
/// evaluate("(2+2)")             -> 4
/// evaluate("(1+(2*4))")         -> 9
/// evaluate("((1+3)+((1+2)*5))") -> 19

func evaluate(_ expr: String) -> Int {
    return Parser(str: expr).expr()
}

/// evaluate("7")                 -> 7
/// evaluate("(2+2)")             -> 4
/// evaluate("(1+(2*4))")         -> 9
/// evaluate("((1+3)+((1+2)*5))") -> 19
print(evaluate("7"))
print(evaluate("(2+2)"))
print(evaluate("(1+(2*4))"))
print(evaluate("((1+3)+((1+2)*5))"))


// manage charactor position
class Source {
    var str: String
    var pos: Int
    
    init(str: String) {
        self.str = str
        self.pos = 0
    }
    
    func peek() -> Character {
        if pos<str.count {
            return str[pos]
        }
        return Character("-")
    }
    
    func incrementPos() {
        self.pos += 1
    }
}


class Parser: Source {
    override init(str: String) {
        super.init(str: str)
    }
    
    // handle extraction of digit
    func number() -> Int {
        var res = ""
        var currChar = peek()
        
        while(
            currChar.isNumber &&
            currChar.isASCII
        ) {
            res.append(String(currChar))
            incrementPos()
            currChar = peek()
            
            //end of string
            if currChar == "-" {
                break
            }
        }
        
        
        return Int(res) ?? 0
    }
    
    // handle addition
    func expr() -> Int {
        var num = term()
        while true {
            switch peek() {
            case "+":
                incrementPos()
                num += term()
            default:
                return num
            }
        }
    }
    
    // handle multiplication
    func term() -> Int {
        var num = factor()
        while true {
            switch peek() {
            case "*":
                incrementPos()
                num *= factor()
            default:
                return num
            }
        }
    }
    
    // handle parenthesis
    func factor() -> Int {
        if peek() == "(" {
            incrementPos()
            let res = expr()
            if peek() == ")" {
                incrementPos()
            }
            return res
        }
        return number()
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
