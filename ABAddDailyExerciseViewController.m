//
//  ABAddDailyExerciseViewController.m
//  StrengthWorkoutLog
//
//  Created by ayenew on 1/22/14.
//  Copyright (c) 2014 com.ayenew. All rights reserved.
//

#import "ABAddDailyExerciseViewController.h"
#import "ABAppDelegate.h"

@interface ABAddDailyExerciseViewController () {
    NSManagedObjectContext *context;
}
@property (weak, nonatomic) IBOutlet UITextField *exerciseTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *setsTextField;
@property (weak, nonatomic) IBOutlet UITextField *repetitionsTextField;

- (IBAction)donePressed:(id)sender;

@end

@implementation ABAddDailyExerciseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	ABAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    context = delegate.managedObjectContext;
    self.exerciseTypeTextField.text = self.exerciseLog.exerciseName;
    [self.exerciseTypeTextField setDelegate:self];
    [self.weightTextField setDelegate:self];
    [self.setsTextField setDelegate:self];
    [self.repetitionsTextField setDelegate:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)donePressed:(id)sender {
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ExerciseLog" inManagedObjectContext:context];
    NSManagedObject *exerciseLog;
    if (self.exerciseLog==nil){
        if (![self.exerciseTypeTextField.text isEqualToString:@""]){
            exerciseLog = [[NSManagedObject alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:context];
            [exerciseLog setValue:self.exerciseTypeTextField.text forKey:@"exerciseName"];
            NSString *weightString = self.weightTextField.text;
            [exerciseLog setValue:[NSNumber numberWithInt:[weightString intValue]] forKey:@"weight"];
            NSString *setsString = self.setsTextField.text;
            [exerciseLog setValue:[NSNumber numberWithInt:[setsString intValue]] forKey:@"sets"];
            NSString *repetitionString = self.repetitionsTextField.text;
            [exerciseLog setValue:[NSNumber numberWithInt:[repetitionString intValue]] forKey:@"repetition"];
            [exerciseLog setValue:[NSDate date] forKey:@"date"];
            NSError *error;
            [context save:&error];
        }
    }
    else {
        self.exerciseLog.exerciseName = self.exerciseTypeTextField.text;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}
@end
