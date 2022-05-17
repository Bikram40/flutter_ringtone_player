#import "FlutterRingtonePlayerPlugin.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation FlutterRingtonePlayerPlugin
NSObject <FlutterPluginRegistrar> *pluginRegistrar = nil;

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    pluginRegistrar = registrar;
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"flutter_ringtone_player"
                  binaryMessenger:[registrar messenger]];
    FlutterRingtonePlayerPlugin *instance = [[FlutterRingtonePlayerPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"play" isEqualToString:call.method]) {
        SystemSoundID soundId = nil;
        CFURLRef soundFileURLRef = nil;

        if (call.arguments[@"uri"] != nil) {
            //NSString *key = [pluginRegistrar lookupKeyForAsset:call.arguments[@"uri"]];
          //NSURL *path = [[NSBundle mainBundle] URLForResource:call.arguments[@"uri"] withExtension:nil];
           NSURL *path = [[NSURL alloc] initFileURLWithPath:call.arguments[@"uri"]];
            soundFileURLRef = CFBridgingRetain(path);
            AudioServicesCreateSystemSoundID(soundFileURLRef, &soundId);
        }
        // The iosSound overrides fromAsset if exists
        if (call.arguments[@"ios"] != nil) {
            soundId = (SystemSoundID) [call.arguments[@"ios"] integerValue];
        }
        AudioServicesPlaySystemSound(soundId);
        if (soundFileURLRef != nil) {
            CFRelease(soundFileURLRef);
        }

            //  NSNumber *strNative = [(unsigned int) soundId];
NSNumber *someNumber = [NSNumber numberWithInt:soundId];
NSLog(@"Value of sum : %@\n",someNumber);
       result(someNumber);
    } else if ([@"stop" isEqualToString:call.method]) {
         if (call.arguments[@"ios"] != nil) {
         SystemSoundID soundId  = (SystemSoundID) [call.arguments[@"ios"] integerValue];
        NSNumber *someNumber2 = [NSNumber numberWithInt:soundId];
        NSLog(@"Value of sum 222 : %@\n",someNumber2);
        AudioServicesDisposeSystemSoundID(soundId);
        }
        
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
