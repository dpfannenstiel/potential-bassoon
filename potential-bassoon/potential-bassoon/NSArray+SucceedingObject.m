//
//  NSArray+SucceedingObject.m
//  potential-bassoon
//
//  Created by Dustin Pfannenstiel on 10/25/17.
//  Copyright © 2017 Dustin Pfannenstiel. All rights reserved.
//

#import "NSArray+SucceedingObject.h"

@implementation NSArray (SucceedingObject)

-(id)objectSucceeding:(NSUInteger)index {
    return (index + 1 < self.count) ? self[index + 1] : nil;
}

@end
