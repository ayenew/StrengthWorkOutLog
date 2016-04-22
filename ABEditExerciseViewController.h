//
//  ABEditExerciseViewController.h
//  StrengthWorkoutLog
//
//  Created by ayenew on 1/26/14.
//  Copyright (c) 2014 com.ayenew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseLog.h"

@interface ABEditExerciseViewController : UITableViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property(nonatomic,strong) NSMutableArray *data;
@property(nonatomic,strong) ExerciseLog *exerciseLog;

@end
