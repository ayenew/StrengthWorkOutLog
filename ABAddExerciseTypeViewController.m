//
//  ABAddExerciseTypeViewController.m
//  StrengthWorkoutLog
//
//  Created by ayenew on 1/22/14.
//  Copyright (c) 2014 com.ayenew. All rights reserved.
//

#import "ABAddExerciseTypeViewController.h"
#import "ABAppDelegate.h"

@interface ABAddExerciseTypeViewController () {
    NSManagedObjectContext *context;
}

@property (weak, nonatomic) IBOutlet UITextField *exerciseNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *exerciseDesc;


- (IBAction)donePressed:(id)sender;

@end

@implementation ABAddExerciseTypeViewController

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
	ABAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    context = delegate.managedObjectContext;
    
    self.exerciseNameTextField.text = self.exercise.exerciseType;
    self.exerciseDesc.text = self.exercise.exerciseDescription;
    
    [self.exerciseNameTextField setDelegate:self];
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:89/255.0  green:138/255.0 blue:243/255.0 alpha:1.0]}];
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)donePressed:(id)sender {
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ExerciseType" inManagedObjectContext:context];
    NSManagedObject *exerciseType;
    if (self.exercise==nil){
        if (![self.exerciseNameTextField.text isEqualToString:@""]){
             exerciseType = [[NSManagedObject alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:context];
            [exerciseType setValue:self.exerciseNameTextField.text forKey:@"exerciseType"];
            [exerciseType setValue:self.exerciseDesc.text forKey:@"exerciseDescription"];
            NSError *error;
            [context save:&error];
        }
    }
    else {
        self.exercise.exerciseType = self.exerciseNameTextField.text;
        self.exercise.exerciseDescription = self.exerciseDesc.text;
        
    }
    
        [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}
@end
