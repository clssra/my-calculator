//
//  ContentView.swift
//  my calculator
//
//  Created by clssra on 22/10/21.
//

import SwiftUI

enum CalcButton: String{
    
    case zero, one, two, three, four, five, six
    case seven, eight, nine, add, subtrack, equal, clear
    case multiply, divide, decimal
    case negative, percent
    
    var title: String {
        switch self {
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .clear: return "AC"
        case .negative: return "+/-"
        case .percent: return "%"
        case .add: return "+"
        case .subtrack: return "-"
        case .multiply: return "*"
        case .divide: return "/"
        case .equal: return "="
        case .decimal: return "."
        
      
        }
    }
    
    
    var buttonColor: Color {
        switch self{
        case .add, .subtrack, .multiply, .divide, .equal:
  //          return Color(.yellow)
           return Color(UIColor(red:255/255.0, green: 196/255.0, blue: 0/255.0, alpha: 1))
        case .clear, .negative, .percent:
            return Color(UIColor(red:42/255.0, green: 80/255.0, blue: 240/255.0, alpha: 1))
        default:
            return Color(UIColor(red:250/255.0, green: 20/255.0, blue: 15/255.0, alpha: 1 ))
     //       return Color(.red)
        }
    }
    
}

//Env object

enum Operation: String {
    case add, subtrack, multiply, divide;
}


class GlobalEnviroment: ObservableObject {
    
    @Published var display = "0"
    
    var oldNum = 0.0
    var newNum = 0.0
    var m = 0
    var oldDisplay = ""
    var temp = 0.0
    
    var op: CalcButton!
    
    
     
    
    func receiveInput(calcButton: CalcButton){
        
        switch calcButton{
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            if m == 0 {
                self.display = calcButton.title
                self.oldDisplay = self.display
                m=1
            } else {
                self.display = self.oldDisplay + calcButton.title
                self.oldDisplay = self.display
            }
            self.newNum = Double(self.display) ?? 0
            break
        case .decimal:
            self.display = self.oldDisplay + "."
            self.oldDisplay = self.display
            break
        case .add, .subtrack, .multiply, .divide:
            self.display = calcButton.title
            self.op = calcButton
            self.oldNum = self.newNum
            self.oldDisplay = ""
            m=0
            break
        case .equal:
            switch self.op{
            case .add:
                //sul display mostro il risultato e salvo il risultato in oldNUm
                temp = self.oldNum + self.newNum

                self.display = String(temp)
                self.newNum = temp
                m=0
                break
            case .subtrack:
                temp = self.oldNum - self.newNum
                self.display = String(temp)
                self.newNum = temp
                break
            case .multiply:
                temp = self.oldNum * self.newNum
                self.display = String(temp)
                self.newNum = temp
                break
            case .divide:
                if self.newNum==0{
                    self.display = "ERROR"
                    break
                }
                temp = self.oldNum / self.newNum
                
                self.display = String(temp)
                self.newNum = temp
                break
            default:
                break
            }
            break
        case .percent:
            self.newNum = self.newNum/100
            self.display = String(self.newNum)
            break
        case .negative:
            self.newNum = -self.newNum
            self.display = String(self.newNum)
            break
        case .clear:
            self.newNum = 0
            self.oldNum = 0
            m = 0
            self.display = String(Int(newNum))
            break
            
            
        }
    }
    
}



struct ContentView: View {
    
    @EnvironmentObject var env: GlobalEnviroment
    
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtrack],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    
    var body: some View {
       
        ZStack{
            Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack{ //vertical stack
                Spacer()
                //Text display
                HStack{
                    Spacer()
                    Text(env.display)
                        .bold()
                        .font(.system(size: 60))
                        .foregroundColor(SwiftUI.Color(UIColor(red:250/255.0, green: 20/255.0, blue: 15/255.0, alpha: 1 )))
                }
                .padding()
                
                //Our buttons
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12){
                        ForEach(row, id: \.self) { button in
                            CalculatorButtonView(button: button)

                        }
                    }
                    .foregroundColor(SwiftUI.Color(UIColor(red:250/255.0, green: 20/255.0, blue: 15/255.0, alpha: 1 )))
                    .padding(.bottom, 3)
                    
                }
            }
        }
    }

    
}

struct CalculatorButtonView: View {
    
    var button: CalcButton
    
    @EnvironmentObject var env: GlobalEnviroment
    
    var body: some View {
        Button(action: {
            self.env.receiveInput(calcButton: button)
        }) {
            Text(button.title)
                .font(.system(size: 32))
                .frame(
                    width: self.buttonWidth(item: button),
                    height:
                        self.buttonHeight())
                .background(button.buttonColor)
                .foregroundColor(.white)
                .cornerRadius(self.buttonWidth(item: button)/2)
        }
            
    }
    
    private func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12))/4)*2
        
        }
        return (UIScreen.main.bounds.width - (5*12))/4
        // (5*12))/4
        // 5 --> because 5 space between buttons. * 12 --> spacing width
        // /4 --> 4 buttons
    }
    
    private func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12))/4
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnviroment())
    }
}
