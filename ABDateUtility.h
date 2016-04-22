//
//  ABDateUtility.h
//  StrengthWorkoutLog
//
//  Created by ayenew on 1/23/14.
//  Copyright (c) 2014 com.ayenew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABDateUtility : NSObject
+ (NSDate *) getStartOfDay:(NSDate *)fromDate;
+ (NSDate *) getEndOfDay:(NSDate *)fromDate;
+ (NSDate *) weekStartdDate :(NSDate *) fromDate;
+ (NSDate *) monthStartDate :(NSDate *) fromDate;
@end
