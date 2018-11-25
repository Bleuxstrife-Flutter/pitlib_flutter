#import "PitCarouselPlugin.h"
#import <pit_carousel/pit_carousel-Swift.h>

@implementation PitCarouselPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPitCarouselPlugin registerWithRegistrar:registrar];
}
@end
