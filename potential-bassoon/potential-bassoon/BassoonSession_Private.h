//
//  BassoonSession_Private.h
//  potential-bassoon
//
//  Created by Dustin Pfannenstiel on 10/25/17.
//  Copyright © 2017 Dustin Pfannenstiel. All rights reserved.
//

#import "BassoonSession.h"

#define DEFAULT_CHUNK_COUNT 4
#define DEFAULT_CHUNK_SIZE 1048576

@interface BassoonSession()

@property (nonatomic) NSUInteger chunkCount;
@property (nonatomic) NSUInteger chunkSize;
@property (nonatomic, nullable, strong) NSURL *source;
@property (nonatomic, nullable, strong) NSURL *destination;
@property (nonatomic, nonnull, strong) NSURLSession *urlSession;

/**
 Generate the Range header string.
 
 @param range The range to generate the header for.
 @returns The value for the Range header.
 */
-(nonnull NSString *)bytesStringFromRange:(NSRange)range;

@end

