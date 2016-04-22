//
//  ABDisplayDailyExerciseViewController.m
//  StrengthWorkoutLog
//
//  Created by ayenew on 1/22/14.
//  Copyright (c) 2014 com.ayenew. All rights reserved.
//

#import "ABDisplayDailyExerciseViewController.h"
#import "ABEditExerciseViewController.h"
#import "ABAppDelegate.h"
#import "ExerciseLog.h"
#import "ABDateUtility.h"


@interface ABDisplayDailyExerciseViewController (){
    NSManagedObjectContext *context;
}

@end

@implementation ABDisplayDailyExerciseViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ABAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    context = delegate.managedObjectContext;
    [self fetchData];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self fetchData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.exerciseLogs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExerciseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    ExerciseLog *exerciseLog = [self.exerciseLogs objectAtIndex:indexPath.row];
    
    UILabel *exerciseNameLabel = (UILabel *)[cell viewWithTag:100];
    exerciseNameLabel.text=exerciseLog.exerciseName;
    UILabel *exerciseResultLabel = (UILabel *)[cell viewWithTag:200];
    exerciseResultLabel.text=[NSString stringWithFormat:@"Weight %@ / Sets %@/ Repetitions %@", exerciseLog.weight, exerciseLog.sets , exerciseLog.repetition];
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *objectToDelete = [self.exerciseLogs objectAtIndex:indexPath.row];
        [context deleteObject:objectToDelete];
        
        [self.exerciseLogs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
        NSError *error;
        if (![context save:&error]){
        
        }
    }
}

-(void) fetchData {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date > %@ and date <=%@",
                             [ABDateUtility getStartOfDay:[NSDate date]], [NSDate date]] ;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
   [request setPredicate:predicate];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ExerciseLog" inManagedObjectContext:context];
    [request setEntity:entityDesc];
     NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"exerciseName" ascending:NO];
    NSArray *sortDescriptor = [[NSArray alloc] initWithObjects:sortDesc, nil];
   [request setSortDescriptors:sortDescriptor];
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
    }
    self.exerciseLogs = mutableFetchResult;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditExerciseSegue"]){
        ABEditExerciseViewController *controller = segue.destinationViewController;
        NSIndexPath *indexPath =[self.tableView indexPathForCell:sender];
        controller.exerciseLog = [self.exerciseLogs objectAtIndex:indexPath.row];
        controller.title = @"Edit Exercise";
    }
    else if ([segue.identifier isEqualToString:@"AddExerciseSegue"]){
        ABEditExerciseViewController *controller = segue.destinationViewController;
        controller.title = @"Add Exercise";
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

@end
