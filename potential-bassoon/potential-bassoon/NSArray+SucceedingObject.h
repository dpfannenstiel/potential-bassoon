//
//  NSArray+SucceedingObject.h
//  potential-bassoon
//
//  Created by Dustin Pfannenstiel on 10/25/17.
//  Copyright © 2017 Dustin Pfannenstiel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray <ObjectType> (SucceedingObject)

-(nullable ObjectType)objectSucceeding:(NSUInteger)index;

@end
