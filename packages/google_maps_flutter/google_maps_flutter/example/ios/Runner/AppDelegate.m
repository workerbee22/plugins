#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

@import GoogleMaps;

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  // Provide the GoogleMaps API key.
  NSString* mapsApiKey = [[NSProcessInfo processInfo] environment][@"YOUR API KEY HERE"];
  if ([mapsApiKey length] == 0) {
    mapsApiKey = @"YOUR API KEY HERE";
  }
  [GMSServices provideAPIKey:mapsApiKey];

  // Register Flutter plugins.
  [GeneratedPluginRegistrant registerWithRegistry:self];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
