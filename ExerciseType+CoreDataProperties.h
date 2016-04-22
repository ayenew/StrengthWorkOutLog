//
//  ExerciseType+CoreDataProperties.h
//  StrengthWorkoutLog
//
//  Created by Ayu on 2/26/16.
//  Copyright © 2016 com.ayenew. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ExerciseType.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExerciseType (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *exerciseDescription;
@property (nullable, nonatomic, retain) NSString *exerciseType;
@property (nullable, nonatomic, retain) NSSet<ExerciseLog *> *exerciseLogs;

@end

@interface ExerciseType (CoreDataGeneratedAccessors)

- (void)addExerciseLogsObject:(ExerciseLog *)value;
- (void)removeExerciseLogsObject:(ExerciseLog *)value;
- (void)addExerciseLogs:(NSSet<ExerciseLog *> *)values;
- (void)removeExerciseLogs:(NSSet<ExerciseLog *> *)values;

@end

NS_ASSUME_NONNULL_END
