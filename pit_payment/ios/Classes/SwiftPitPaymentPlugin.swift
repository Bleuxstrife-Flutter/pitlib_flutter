import Flutter
import UIKit
import MidtransCoreKit

struct Midtrans{
    static var clientKey: String{
        //        return "VT-client-ZgRC-r-WntD2epbI"; //production
        return "VT-client-j_y7RRFZJETHsqMe"; //debug
    }
    static var merchantServerUrl: String{
        //        return "https://api.veritrans.co.id/v2/transactions"; //production
        return "https://api.sandbox.veritrans.co.id/v2/transactions"; //debug
    }
    static var serverEnvironment: MidtransServerEnvironment{
        //        return .production; //production
        return .sandbox; //debug
    }
}

public class SwiftPitPaymentPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "pit_payment", binaryMessenger: registrar.messenger())
        let instance = SwiftPitPaymentPlugin()
        
        MidtransConfig.shared().setClientKey(Midtrans.clientKey, environment: Midtrans.serverEnvironment, merchantServerURL: Midtrans.merchantServerUrl)
        
        MidtransCreditCardConfig.shared().secure3DEnabled = true
        
        MidtransCreditCardConfig.shared().tokenStorageEnabled = true
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //        result("iOS " + UIDevice.current.systemVersion + " \(call.method)")
        print("call method => \(call.method)")
        if call.method == "generateCreditCardToken" {
            generateCreditCardToken( call, result: result);
        } else {
            result("Method not implemented");
        }
    }
    
    public func generateCreditCardToken(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        if let args = call.arguments as? Dictionary<String, Any> {
            var creditCard: MidtransCreditCard = MidtransCreditCard();
            var amount: Double = 0.0;
            
            let creditCardRaw = args["creditCard"] as? String ?? ""
            
            do {
                let data : Data = creditCardRaw.data(using: .utf8)!
                guard let creditCardJSON =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    else { return }
                
                let creditCardNumber = creditCardJSON["creditCardNumber"] as? String ?? ""
                let expiryMonth = creditCardJSON["expiryMonth"] as? Int ?? 0
                let expiryYear = creditCardJSON["expiryYear"] as? Int ?? 0
                let cvv = creditCardJSON["cvv"] as? Int ?? 0
                amount = creditCardJSON["amount"] as? Double ?? 0.0
                
                creditCard = MidtransCreditCard(number: creditCardNumber, expiryMonth: String(expiryMonth), expiryYear: String(expiryYear), cvv: String(cvv))
            } catch {
                result("error parsing: \(error.localizedDescription)");
            }
            
            let tokenRequest = MidtransTokenizeRequest(creditCard: creditCard, grossAmount: NSNumber(integerLiteral: Int(amount)), secure: true)!
            
            if creditCard.number != nil{
                MidtransClient.shared().generateToken(tokenRequest) { ccToken, error in
                    DispatchQueue.main.async {
                        if let error = error{
                            result("error: \(error.localizedDescription)");
                        }
                        result("ccToken: \(ccToken ?? "")");
                    }
                }
            }else{
                result("error: Invalid Credit Card Data!");
            }
        } else {
            result("error: Bad Arguments!");
        }
    }
    //    func parseJson(anyObj:AnyObject) -> Array<Business>{
    //
    //        var list:Array<Business> = []
    //
    //        if  anyObj is Array<AnyObject> {
    //
    //            var b:Business = Business()
    //
    //            for json in anyObj as Array<AnyObject>{
    //                b.name = (json["name"] as AnyObject? as? String) ?? "" // to get rid of null
    //                b.id  =  (json["id"]  as AnyObject? as? Int) ?? 0
    //
    //                list.append(b)
    //            }// for
    //
    //        } // if
    //
    //        return list
    //
    //    }//func
}

