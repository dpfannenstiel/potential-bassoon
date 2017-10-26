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

/**
 Process a candidate chunk count string.
 
 The string is changed into an integer using `integerValue` and then
 applied to the chunkCount property.  If the integer is then greater than
 0 processing is considered complete.
 
 @param count The string to process.
 @returns Return `nil` if procssing succedes, otherwise an error string.
 */
-(nullable NSString *)processCountComponent:(nullable NSString *)count;

/**
 Process a candidate chunk size string.
 
 The string is changed into an integer using `integerValue` and then
 applied to the chunkSize property.  If the integer is then greater than
 0 processing is considered complete.
 
 @param size The string to process.
 @returns Return `nil` if procssing succedes, otherwise an error string.
 */
-(nullable NSString *)processSizeComponent:(nullable NSString *)size;

@end

