//
//  ABEditExerciseViewController.m
//  StrengthWorkoutLog
//
//  Created by ayenew on 1/26/14.
//  Copyright (c) 2014 com.ayenew. All rights reserved.
//

#import "ABEditExerciseViewController.h"
#import "ABAppDelegate.h"
#import "ExerciseType.h"


#define kDataPickerIndex 1
#define kDataPickerCellHeight 164

@interface ABEditExerciseViewController (){
    NSManagedObjectContext *context;
}

@property (assign) BOOL dataPickerIsShowing;

- (IBAction)savePressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITableViewCell *dataPickerCell;
@property (weak, nonatomic) IBOutlet UILabel *exerciseLabel;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *setsTextField;
@property (weak, nonatomic) IBOutlet UITextField *repetitionsTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *exercisePickerView;

@property (strong, nonatomic) UITextField *activeTextField;

@end

@implementation ABEditExerciseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    ABAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    context= delegate.managedObjectContext;
    
    [self.exercisePickerView setDelegate:self];
    [self.exercisePickerView setDataSource:self];
    [self.weightTextField setDelegate:self];
    [self.setsTextField setDelegate:self];
    [self.repetitionsTextField setDelegate:self];
    [self grabData];
    
    [self setupInitialLabel];
    
    [self signUpForKeyboardNotifications];

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.exerciseLog==nil) {
    int row =(int)[self.data count]/2;
    [self.exercisePickerView selectRow:row inComponent:0 animated:YES];
    }
    else{
        self.exerciseLabel.text= self.exerciseLog.exerciseName;
        self.weightTextField.text = [self.exerciseLog.weight stringValue];
        self.setsTextField.text = [self.exerciseLog.sets stringValue];
        self.repetitionsTextField.text= [self.exerciseLog.repetition stringValue];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper methods

- (void)setupInitialLabel {
    
    self.exerciseLabel.text = @"Select Exercise";
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)keyboardWillShow {
    
    if (self.dataPickerIsShowing){
        [self hideDatePickerCell];
    }
}

#pragma mark - Table view methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = self.tableView.rowHeight;
    if (indexPath.row == kDataPickerIndex){
        height = self.dataPickerIsShowing ? kDataPickerCellHeight : 0.0f;
        if (height == 0.0f)
           self.exercisePickerView.hidden = YES;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        if (self.dataPickerIsShowing){
            [self hideDatePickerCell];
        }
        else if ([self.data count]<=0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Exercise Type Found" message:@"Please enter exercise types first" delegate:self cancelButtonTitle:@" OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            [self.activeTextField resignFirstResponder];
            [self showDatePickerCell];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showDatePickerCell {
    
    self.dataPickerIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.exercisePickerView.hidden = NO;
    self.exercisePickerView.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
    self.exercisePickerView.alpha = 1.0f;
    }];
}

- (void)hideDatePickerCell {
    
    self.dataPickerIsShowing = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.exercisePickerView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.exercisePickerView.hidden = YES;
                     }];
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    
}


#pragma mark picker view

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.data count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.data!=nil) {
        ExerciseType *exerciseType = [self.data objectAtIndex:row];
        return exerciseType.exerciseType;
    }
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    ExerciseType *exerciseType = [self.data objectAtIndex:row];
    self.exerciseLabel.text = exerciseType.exerciseType;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    
    
}

-(void) grabData {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ExerciseType" inManagedObjectContext:context];
    [request setEntity:entityDesc];
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[context executeFetchRequest:request error:&error] mutableCopy];
    //
    if (mutableFetchResult == nil) {
        //        //
    }
    self.data = mutableFetchResult;
    
}
- (IBAction)savePressed:(id)sender {
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ExerciseLog" inManagedObjectContext:context];
    NSManagedObject *exerciseLog;
    if (self.exerciseLog==nil){
        if (![self.exerciseLabel.text isEqualToString:@""]&&![self.exerciseLabel.text isEqualToString:@"Select Exercise"]){
            exerciseLog = [[NSManagedObject alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:context];
            [exerciseLog setValue:self.exerciseLabel.text forKey:@"exerciseName"];
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
        self.exerciseLog.exerciseName = self.exerciseLabel.text;
        self.exerciseLog.weight = [NSNumber numberWithInt:[self.weightTextField.text intValue]];
        self.exerciseLog.sets = [NSNumber numberWithInt:[self.setsTextField.text intValue]];
        self.exerciseLog.repetition = [NSNumber numberWithInt:[self.repetitionsTextField.text intValue]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end