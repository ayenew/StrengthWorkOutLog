//
//  ABDayViewController.m
//  StrengthWorkoutLog
//
//  Created by ayenew on 2/3/14.
//  Copyright (c) 2014 com.ayenew. All rights reserved.
//

#import "ABDayViewController.h"
#import "ExerciseLog.h"
#import "ABAppDelegate.h"

@interface ABDayViewController (){
    NSManagedObjectContext *context;
}

@end

@implementation ABDayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    ABAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    context = delegate.managedObjectContext;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.exerciseLog count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    ExerciseLog *exerciseLog = [self.exerciseLog objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    UILabel *exerciseName = (UILabel *)[cell viewWithTag:100];
    exerciseName.text = exerciseLog.exerciseName;
    UILabel *exerciseDetail= (UILabel *)[cell viewWithTag:200];
    exerciseDetail.text = [NSString stringWithFormat:@"%@ - Weight %@/Sets %@/Rep %@",[dateFormatter stringFromDate:exerciseLog.date],[exerciseLog weight], [exerciseLog sets], [exerciseLog repetition]];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSManagedObject *objectToDelete = [self.exerciseLog objectAtIndex:indexPath.row];
            [context deleteObject:objectToDelete];
            
            [self.exerciseLog removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
            
            NSError *error;
            if (![context save:&error]){
                
            }
        }
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end
