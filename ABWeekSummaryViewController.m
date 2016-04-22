//
//  ABWeekSummaryViewController.m
//  StrengthWorkoutLog
//
//  Created by ayenew on 1/23/14.
//  Copyright (c) 2014 com.ayenew. All rights reserved.
//

#import "ABWeekSummaryViewController.h"
#import "ABAppDelegate.h"
#import "ABDateUtility.h"
#import "ExerciseLog.h"

@interface ABWeekSummaryViewController () {
    NSManagedObjectContext *context;

}
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ABWeekSummaryViewController

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
    
    NSError *error;
    
	if (![self.fetchedResultsController performFetch:&error])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Application Error" message:@"Please relaunch the App" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
	}
 //   UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
//    [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgnd.png"]]];
//    [self.tableView setBackgroundView:backgroundView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    abort();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger count = [[self.fetchedResultsController sections] count];
	return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
	NSInteger count = [sectionInfo numberOfObjects];
	return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	ExerciseLog *log = [self.fetchedResultsController objectAtIndexPath:indexPath];

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    UILabel *exerciseDateLabel = (UILabel *)[cell viewWithTag:100];
    exerciseDateLabel.text=[formatter stringFromDate:log.date];
    
    UILabel *results = (UILabel *)[cell viewWithTag:200];
    results.text = [NSString stringWithFormat:@"Weight %@ /Sets %@ /Repetitions %@",[log weight], [log sets], [log repetition]];
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    
	return [theSection name]; ;
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    /*
	 Set up the fetched results controller.
     */
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExerciseLog" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >= %@ and date <=%@",
                              [ABDateUtility weekStartdDate:[NSDate date]], [NSDate date]] ;
    [fetchRequest setPredicate:predicate];
    
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
    
	// Sort using the timeStamp property.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	[fetchRequest setSortDescriptors:@[sortDescriptor ]];
    
    // Use the sectionIdentifier property to group into sections.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"exerciseName" cacheName:nil];
    _fetchedResultsController.delegate = self;
	return _fetchedResultsController;
}    

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
      cell.backgroundColor = [UIColor colorWithRed:255/255.0  green:250/255.0 blue:243/255.0 alpha:1.0];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont boldSystemFontOfSize:16];
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
}

@end
