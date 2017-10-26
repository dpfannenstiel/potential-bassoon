//
//  UnitTests.m
//  UnitTests
//
//  Created by Dustin Pfannenstiel on 10/25/17.
//  Copyright © 2017 Dustin Pfannenstiel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BassoonSession.h"
#import "BassoonSession_Private.h"
#import "NSArray+SucceedingObject.h"

@interface UnitTests : XCTestCase

@property (nonatomic, strong) BassoonSession *session;

@end

@implementation UnitTests

- (void)setUp {
    [super setUp];
    self.session = [BassoonSession new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSucceedingObject {

    NSString *firstObject = @"A";
    NSString *secondObject = @"B";
    NSString *thirdObject = @"C";
    NSArray <NSString *> *array = @[firstObject, secondObject, thirdObject];
    XCTAssertEqual([array objectSucceeding:0], secondObject);
    XCTAssertEqual([array objectSucceeding:1], thirdObject);
    XCTAssertEqual([array objectSucceeding:2], nil);
    
}

- (void)testCountComponentProcessing {

    XCTAssertEqual(self.session.chunkCount, DEFAULT_CHUNK_COUNT);
    NSString *message = [self.session processCountComponent:@"1"];
    XCTAssertNil(message);
    XCTAssertEqual(self.session.chunkCount, 1);
    message = [self.session processCountComponent:@"-1"];
    XCTAssertNotNil(message);
    XCTAssertEqual(self.session.chunkCount, -1);
    
}

- (void)testSizeComponentProcessing {
    XCTAssertEqual(self.session.chunkSize, DEFAULT_CHUNK_SIZE);
    NSString *message = [self.session processSizeComponent:@"1024"];
    XCTAssertNil(message);
    XCTAssertEqual(self.session.chunkSize, 1024);
    message = [self.session processSizeComponent:@"-1024"];
    XCTAssertNotNil(message);
    XCTAssertEqual(self.session.chunkSize, -1024);

}

- (void)testByteRangeHeader {
    NSString *byteRange = [self.session bytesStringFromRange:NSMakeRange(255, 1)];
    XCTAssertTrue([byteRange isEqualToString:@"bytes=255-255"]);
    byteRange = [self.session bytesStringFromRange:NSMakeRange(0, 20)];
    XCTAssertTrue([byteRange isEqualToString:@"bytes=0-19"]);
    XCTAssertThrows([self.session bytesStringFromRange:NSMakeRange(0, 0)]);
    XCTAssertThrows([self.session bytesStringFromRange:NSMakeRange(0, NSNotFound)]);
    XCTAssertThrows([self.session bytesStringFromRange:NSMakeRange(NSNotFound, 1)]);
}

@end
