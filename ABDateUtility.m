//
//  ABDateUtility.m
//  StrengthWorkoutLog
//
//  Created by ayenew on 1/23/14.
//  Copyright (c) 2014 com.ayenew. All rights reserved.
//

#import "ABDateUtility.h"

@implementation ABDateUtility

//Start of the day
+ (NSDate *) getStartOfDay:(NSDate *)fromDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comp = [gregorian components:( NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:fromDate];
    [comp setMinute:0];
    [comp setHour:0];
    [comp setSecond:0];
    
    NSDate *startOfToday = [gregorian dateFromComponents:comp];
    return startOfToday;
}

//End of the day
+ (NSDate *) getEndOfDay:(NSDate *)fromDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [NSDateComponents new];
    components.day = 1;
    
    NSDate *date = [calendar dateByAddingComponents:components
                                             toDate:fromDate
                                            options:0];
    
    date = [date dateByAddingTimeInterval:-1];
    return date;

}

//Week Start Date
+ (NSDate *)weekStartdDate:(NSDate *)fromDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:fromDate];
    [components setMinute:0];
    [components setHour:0];
    [components setSecond:0];
    int dayofweek = (int)[[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:fromDate] weekday];
    [components setDay:([components day] - ((dayofweek) - 2))];
    NSDate *weekstartPrev = [gregorian dateFromComponents:components];
    return weekstartPrev;
    
}

 //Start of the month
+ (NSDate *)monthStartDate :(NSDate *) fromDate{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:fromDate];
    [components setMinute:0];
    [components setHour:0];
    [components setSecond:0];
    NSDate *startOfMonth = [gregorian dateFromComponents:components];
    return startOfMonth;
}

@end
