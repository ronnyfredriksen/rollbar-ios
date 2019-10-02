//
//  main.m
//  macOScmdTool
//
//  Created by Andrey Kornich on 2019-06-28.
//  Copyright © 2019 Andrey Kornich (Wide Spectrum Computing LLC). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../../../Rollbar/Rollbar.h"
#import "../../../Rollbar/RollbarConfiguration.h"
#import "../../../Rollbar/RollbarTelemetry.h"
//#import <NSJSONSerialization+Rollbar.h>

@interface BuggyClass : NSObject

@end

@implementation BuggyClass

+ (void) callTroubleMaker {
    [self causeTrouble];
}

+ (void) causeTrouble {
    
    NSArray *crew = [NSArray arrayWithObjects:
                     @"Dave",
                     @"Heywood",
                     @"Frank", nil];
    // This will throw an exception.
    NSLog(@"%@", [crew objectAtIndex:10]);
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // configure Rollbar:
        RollbarConfiguration *config = [RollbarConfiguration configuration];
        config.environment = @"samples";
        [Rollbar initWithAccessToken:@"2ffc7997ed864dda94f63e7b7daae0f3" configuration:config];
        
        NSLog(@"Hello, World!");
        
        @try {
            [BuggyClass callTroubleMaker];
        }
        @catch (NSException *exception) {
            
            [Rollbar critical:@"Caught an exception while invoking BuggyClass"
                    exception:exception
             ];
        }

        
        int i = 100;
        while (0 < i--) {
            [Rollbar info:@"Message from macOScmdTool"];
            [NSThread sleepForTimeInterval:1.0f];
        }
    }
    return 0;
}
