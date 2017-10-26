//
//  BassoonSession.m
//  potential-bassoon
//
//  Created by Dustin Pfannenstiel on 10/25/17.
//  Copyright © 2017 Dustin Pfannenstiel. All rights reserved.
//

#import "BassoonSession_Private.h"
#import "NSArray+SucceedingObject.h"

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
    NSParameterAssert(argumentsArray.count > 0);
    
    NSString *response = nil;

    if (argumentsArray.count == 1) {
        response = [self helpResponse];
    }
    
    // Process the array values.
    for (NSUInteger i = 1; i < argumentsArray.count; i++) {
        NSString *s = argumentsArray[i];
        
        if ([s isEqualToString:@"-o"]) {
            response = [self processFileComponent:[argumentsArray objectSucceeding:i]];
            i++;
            
        }/* else if ([s isEqualToString:@"--parallel"] || [s isEqualToString:@"-p"]) {
            
        }*/ else if (s == argumentsArray.lastObject) {
            response = [self processSourceURLString:s];
            if (self.destination == nil) {
                NSString *lastPath = self.source.path.lastPathComponent;
                lastPath = lastPath.length > 0 ? lastPath : @"a.out"; // Provide an absolute default for the out file.
                response = [self processFileComponent:lastPath];
            }
        }
#ifdef DEBUG
// In the debug configuration, allow additional flags for development purposes.
        else if ([s isEqualToString:@"--size"] || [s isEqualToString:@"-s"]) {
            response = [self processSizeComponent:[argumentsArray objectSucceeding:i]];
            i++;
        } else if ([s isEqualToString:@"--count"] || [s isEqualToString:@"-c"]) {
            response = [self processCountComponent:[argumentsArray objectSucceeding:i]];
            i++;
        }
#endif
        else {
            // An unknown value has been input, generate the help text.
            response = [self helpResponse];
        }
        
        if (response != nil) {
            break;
        }
    }
    
    return response;
}

-(NSString *)helpResponse {
    NSString *response = @"Usage ./potential-bassoon [OPTIONS] url \n"
    "-o string \n\tWrite output to <file> instead of default"
    /*"\n--parallel -p\n\tDownload chunks in parallel instead of sequentally"*/;
#ifdef DEBUG
    // In the debug configuration, document the additional flags.
    NSString *debugAppendix = @"\n"
    "--size -s unsigned int\n\tSize of the chunks\n"
    "--count -c unsigned int\n\tNumber of chunks";
    response = [response stringByAppendingString:debugAppendix];
#endif
    return response;
}

-(NSInteger)requestData {
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    NSArray <NSMutableData *> *data = [NSArray array];
    for (NSUInteger i = 0; i < self.chunkCount; i ++) {
        dispatch_group_enter(serviceGroup);
        NSMutableData *chunk = [self dataForChunk:i onServiceGroup:serviceGroup];
        data = [data arrayByAddingObject:chunk];
    }
    dispatch_group_wait(serviceGroup,DISPATCH_TIME_FOREVER);
    
    
    __block BOOL success = YES;
    NSMutableData *blob = [NSMutableData new];
    [data enumerateObjectsUsingBlock:^(NSMutableData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        success = [obj length] > 0;
        [blob appendData:obj];
    }];
    
    if (success) {
        [self writeData:blob];
    }
    
    return success ? blob.length : -1;
}

-(void)writeData:(NSData *)data {
    [data writeToURL:self.destination atomically:YES];
}

-(NSMutableData *)dataForChunk:(NSUInteger)chunkNumber onServiceGroup:(dispatch_group_t)serviceGroup {
    
    NSURLRequest *request = [self requestForChunk:chunkNumber];
    NSMutableData *chunkData = [NSMutableData new];
    [[self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [chunkData setData:data];
        dispatch_group_leave(serviceGroup);
    }] resume];
 
    return chunkData;
}

-(NSString *)processCountComponent:(NSString *)count {
    NSInteger value = [count integerValue];
    self.chunkCount = value;
    // Developers note: NSInteger and NSUInteger are assigned via
    // bit assignment, therefore one may be assigned to another.
    // A stronger typesaftey system sould prevent this,
    // until migrating to Swift, this assignment may be incovienient,
    // but will not break the app.
    
    // Check the value since it is signed.
    return (value < 1) ? @"Positive chunk values are required." : nil;
}

-(NSString *)processSizeComponent:(NSString *)size {
    NSInteger value = [size integerValue];
    self.chunkSize = value;
    return (value < 1) ? @"Positive chunk sizes are required." : nil;
}

// TODO: Document This
// TODO: Test This
-(NSString *)processFileComponent:(NSString *)file {
    self.destination = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:file];
    NSString *result = nil;
    result = [[NSFileManager defaultManager] fileExistsAtPath:self.destination.path] ? [NSString stringWithFormat:@"File Already Exists: %@", file] : result;
    result = [[NSFileManager defaultManager] isWritableFileAtPath:self.destination.path] ? [NSString stringWithFormat:@"Cannot Write To File: %@", file] : result;
    return result;
}

-(NSString *)processSourceURLString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    self.source = url;
    return url == nil ? [NSString stringWithFormat:@"Unable to generate url from: %@", urlString] : nil;
}

-(NSURLRequest *)requestForChunk:(NSUInteger)chunk {
    NSRange range = NSMakeRange(chunk * self.chunkSize, self.chunkSize);
    return [self chunkRequestOnRange:range];
}

-(NSURLRequest *)chunkRequestOnRange:(NSRange)range {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.source];
    request.HTTPMethod = @"GET";
    [request setValue:[self bytesStringFromRange:range] forHTTPHeaderField:@"Range"];
    return request;
}

-(NSString *)bytesStringFromRange:(NSRange)range {
    NSParameterAssert(range.length > 0);
    NSParameterAssert(range.length != NSNotFound);
    NSParameterAssert(range.location != NSNotFound);
    NSUInteger startIndex = range.location;
    NSUInteger endIndex = range.location + range.length - 1;
    return [NSString stringWithFormat:@"bytes=%lu-%lu", startIndex, endIndex];
}

@end
