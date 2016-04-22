//
//  ABDaySummaryViewController.m
//  StrengthWorkoutLog
//
//  Created by ayenew on 2/3/14.
//  Copyright (c) 2014 com.ayenew. All rights reserved.
//

#import "ABDaySummaryViewController.h"
#import "ExerciseLog.h"
#import "ABAppDelegate.h"
#import "ABDayViewController.h"
#import "ABDateUtility.h"

#define kStartDatePickerIndex 1
#define kendDatePickerIndex 3
#define kDatePickerCellHeight 164

@interface ABDaySummaryViewController () {
    NSManagedObjectContext *context;
}

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property(nonatomic, strong)NSMutableArray *data;

@property (assign) BOOL startDatePickerIsShowing;
@property (assign) BOOL endDatePickerIsShowing;

@property (weak, nonatomic) IBOutlet UITableViewCell *startDatePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDatePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;



@end

@implementation ABDaySummaryViewController
NSInteger  flag;
NSDate *startDate;
NSDate *endDate;
- (void)viewDidLoad {
    [super viewDidLoad];
    ABAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    context = delegate.managedObjectContext;
    [self setupDateLabel];
    
    [self signUpForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper methods

- (void)setupDateLabel {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *defaultDate = [NSDate date];
    
    self.startDateLabel.text = [self.dateFormatter stringFromDate:defaultDate];
    self.startDateLabel.textColor = [self.tableView tintColor];
    
    self.endDateLabel.text = [self.dateFormatter stringFromDate:defaultDate];
    self.endDateLabel.textColor = [self.tableView tintColor];
    
   
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)keyboardWillShow {
    
    if (self.startDatePickerIsShowing){
        
        [self hideDatePickerCell];
    }
    if (self.endDatePickerIsShowing){
        
        [self hideDatePickerCell];
    }
}

#pragma mark - Table view methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.row == kStartDatePickerIndex){
        height = self.startDatePickerIsShowing ? kDatePickerCellHeight : 0.0f;
        if (height == 0.0f)
            self.startDatePicker.hidden = YES;
    }
    else if (indexPath.row == kendDatePickerIndex){
        height = self.endDatePickerIsShowing ? kDatePickerCellHeight : 0.0f;
        if (height == 0.0f)
            self.endDatePicker.hidden = YES;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0){
        flag=indexPath.row;
        if (self.startDatePickerIsShowing){
            
            [self hideDatePickerCell];
            
        }else {
        
        
          [self showDatePickerCell];
        }
    }

    else if (indexPath.row == 2){
        flag=indexPath.row;
        if (self.endDatePickerIsShowing){
            
            [self hideDatePickerCell];
            
        }else {
            
            
            [self showDatePickerCell];
        }

    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showDatePickerCell {
    if (flag == 0) {
    self.startDatePickerIsShowing = YES;
    self.startDatePicker.hidden = NO;
    self.startDatePicker.alpha = 0.0f;
        
    [UIView animateWithDuration:0.25 animations:^{
            
            self.startDatePicker.alpha = 1.0f;
            
        }];
    }
    else if (flag == 2){
    self.endDatePickerIsShowing = YES;
    self.endDatePicker.hidden = NO;
    self.endDatePicker.alpha = 0.0f;
        [UIView animateWithDuration:0.25 animations:^{
            
            self.endDatePicker.alpha = 1.0f;
            
        }];
    }
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
}

- (void)hideDatePickerCell {
    
    self.startDatePickerIsShowing = NO;
    self.endDatePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.startDatePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.startDatePicker.hidden = YES;
                     }];
}

#pragma mark - Action methods

- (IBAction)pickerDateChanged:(UIDatePicker *)sender {
    
    if(sender==self.startDatePicker){
    self.startDateLabel.text =  [self.dateFormatter stringFromDate:sender.date];
    }
    else {
        self.endDateLabel.text =  [self.dateFormatter stringFromDate:sender.date];

    }
}

- (IBAction)fetchData:(id)sender {
   }

-(void) grabData {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ExerciseLog" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date > %@ and date <=%@",
                              [ABDateUtility getStartOfDay:startDate], [ABDateUtility getEndOfDay:endDate]] ;
    
    [request setPredicate:predicate];
    [request setEntity:entityDesc];
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[context executeFetchRequest:request error:&error] mutableCopy];

    if (mutableFetchResult == nil) {
 
    }
    self.data = mutableFetchResult;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        ABDayViewController *controller = segue.destinationViewController;
        controller.exerciseLog = self.data;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"DaySegue"]){
        NSString *strStartDate = [self.startDateLabel text];
        NSString *strEndDate = [self.endDateLabel text];
        startDate =[self.dateFormatter dateFromString:strStartDate];
        endDate =[self.dateFormatter dateFromString:strEndDate];
        if ([startDate compare:endDate] == NSOrderedDescending) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Date Problem" message:@"Start Date should not be later than End Date" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
        else {
            [self grabData];
            return YES;
        }
  }
    return NO;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:89/255.0  green:138/255.0 blue:243/255.0 alpha:1.0];
}

@end
