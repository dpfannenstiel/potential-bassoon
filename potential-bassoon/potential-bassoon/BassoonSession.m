//
//  BassoonSession.m
//  potential-bassoon
//
//  Created by Dustin Pfannenstiel on 10/25/17.
//  Copyright © 2017 Dustin Pfannenstiel. All rights reserved.
//

#import "BassoonSession_Private.h"

@implementation BassoonSession

-(instancetype)init {
    if ((self = [super init])) {
        self.chunkCount = DEFAULT_CHUNK_COUNT;
        self.chunkSize = DEFAULT_CHUNK_SIZE;
        self.urlSession = [NSURLSession sharedSession];
    }
    return self;
}

-(NSString *)parseArgumentsArray:(NSArray<NSString *> *)argumentsArray {
    NSString *response = nil;

    for (NSUInteger i = 0; i < argumentsArray.count; i++) {
        NSString *s = argumentsArray[i];
        
        if ([s isEqualToString:@"-o"]) {
            i++;
            
        } else if ([s isEqualToString:@"--parallel"] || [s isEqualToString:@"-p"]) {
            
        } else if (s == argumentsArray.lastObject) {
            
        }
#ifdef DEBUG
// In the debug configuration, allow additional flags for development purposes.
        else if ([s isEqualToString:@"--size"] || [s isEqualToString:@"-s"]) {
            
        } else if ([s isEqualToString:@"--count"] || [s isEqualToString:@"-c"]) {
            
        }
#endif
        else {
            response = @"Usage ./potential-bassoon [OPTIONS] url \n"
                        "-o string \n\tWrite output to <file> instead of default\n"
                        "--parallel -p\n\tDownload chunks in parallel instead of sequentally";
#ifdef DEBUG
// In the debug configuration, document the additional flags.
            NSString *debugAppendix = @"\n"
                                       "--size -s\n\tSize of the chunks\n"
                                       "--count -c\n\tNumber of chunks";
            response = [response stringByAppendingString:debugAppendix];
#endif
        }
        
        if (response != nil) {
            break;
        }
    }
    
    return response;
}

-(BOOL)requestData {
    return YES;
}

-(NSURLRequest *)chunkRequestOnRange:(NSRange)range {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.source];
    request.HTTPMethod = @"GET";
    request setValue:<#(nullable NSString *)#> forHTTPHeaderField:<#(nonnull NSString *)#>
}

-(NSString *)bytesStringFromRange:(NSRange)range {
    NSUInteger startIndex = range.location;
    NSUInteger endIndex = range.location + range.length;
    
}

@end
