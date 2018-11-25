#import "PitPaymentPlugin.h"
#import <pit_payment/pit_payment-Swift.h>

@implementation PitPaymentPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPitPaymentPlugin registerWithRegistrar:registrar];
}
@end
