//
//  BassoonSession.h
//  potential-bassoon
//
//  Created by Dustin Pfannenstiel on 10/25/17.
//  Copyright © 2017 Dustin Pfannenstiel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BassoonSession : NSObject

/// Number of chunks to download the URL in.
@property (nonatomic, readonly) NSUInteger chunkCount;

/// Size of the chunk in MiB to download the URL in.
@property (nonatomic, readonly) NSUInteger chunkSize;

/// URL to download.
@property (nonatomic, nullable, readonly) NSURL *source;

/// URL to store the data.
@property (nonatomic, nullable, readonly) NSURL *destination;

/**
 Parse the string array into native types for use as arguments.
 
 @returns Returns `nil` if all arguments have been parsed correctly.  Otherwise returns the a string describing what component failed.
 */
-(nullable NSString *)parseArgumentsArray:(nonnull NSArray <NSString *> *)argumentsArray;

/**
 Request the data from the provided URL according to the passed arguments.
 
 This method is synchronous and returns only when the final success or failure of the network calls have been achieved.
 
 @returns Returns `YES` if the network request calls have all completed successfully.  `NO` if one or more request has failed.
 */
-(BOOL)requestData;


@end
