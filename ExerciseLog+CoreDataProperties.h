//
//  ExerciseLog+CoreDataProperties.h
//  StrengthWorkoutLog
//
//  Created by Ayu on 2/26/16.
//  Copyright © 2016 com.ayenew. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ExerciseLog.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExerciseLog (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *exerciseName;
@property (nullable, nonatomic, retain) NSNumber *repetition;
@property (nullable, nonatomic, retain) NSNumber *sets;
@property (nullable, nonatomic, retain) NSNumber *weight;
@property (nullable, nonatomic, retain) ExerciseType *exerciseType;

@end

NS_ASSUME_NONNULL_END
