#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

@import GoogleMaps;

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  // Provide the GoogleMaps API key.
  NSString* mapsApiKey = [[NSProcessInfo processInfo] environment][@"AIzaSyDg-1ItPN6Yz0b5PJALDLytqrVkaObF0AM"];
  if ([mapsApiKey length] == 0) {
    mapsApiKey = @"AIzaSyDg-1ItPN6Yz0b5PJALDLytqrVkaObF0AM";
  }
  [GMSServices provideAPIKey:mapsApiKey];

  // Register Flutter plugins.
  [GeneratedPluginRegistrant registerWithRegistry:self];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
