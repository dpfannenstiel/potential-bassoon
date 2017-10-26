//
//  main.m
//  potential-bassoon
//
//  Created by Dustin Pfannenstiel on 10/24/17.
//  Copyright © 2017 Dustin Pfannenstiel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BassoonSession.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSDate *start = [NSDate date];
        BassoonSession *session = [BassoonSession new];
        NSArray <NSString *> *arguments = [[NSProcessInfo processInfo] arguments];
        NSString *argumentMessage = [session parseArgumentsArray:arguments];
        if (argumentMessage) {
            // An error has occurred processing the arguments.
            NSLog(@"%@", argumentMessage);
            return 1;
        }
        NSInteger bytes = [session requestData];
        if (bytes > -1) {
            NSLog(@"%lu bytes downloaded in %f seconds.", bytes, [[NSDate date] timeIntervalSinceDate:start]);
        } else {
            NSLog(@"An unknown error has occurred during download.");
            return 1;
        }
    }
    return 0;
}
