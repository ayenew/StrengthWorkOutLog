//
//  ABAddDailyExerciseViewController.h
//  StrengthWorkoutLog
//
//  Created by ayenew on 1/22/14.
//  Copyright (c) 2014 com.ayenew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseLog.h"

@interface ABAddDailyExerciseViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,strong)ExerciseLog *exerciseLog;

@end
