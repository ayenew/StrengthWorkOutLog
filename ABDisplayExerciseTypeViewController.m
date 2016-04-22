//
//  ABDisplayExerciseTypeViewController.m
//  StrengthWorkoutLog
//
//  Created by ayenew on 1/22/14.
//  Copyright (c) 2014 com.ayenew. All rights reserved.
//

#import "ABDisplayExerciseTypeViewController.h"
#import "ABAddExerciseTypeViewController.h"
#import "ExerciseType.h"

@interface ABDisplayExerciseTypeViewController () {
    NSManagedObjectContext *context;
}

@end

@implementation ABDisplayExerciseTypeViewController
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
    
    ABAppDelegate *delegate= [[UIApplication sharedApplication] delegate];
    context = delegate.managedObjectContext;
    
    [self grabData];

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self grabData];
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
    return [self.exerciseTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExerciseTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    ExerciseType *type = [self.exerciseTypes objectAtIndex:indexPath.row];
    cell.textLabel.text = type.exerciseType;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:131/255.0  green:164/255.0 blue:255/255.0 alpha:1.0];
    }
    else{
        cell.backgroundColor = [UIColor colorWithRed:217/255.0  green:233/255.0 blue:255/255.0 alpha:1.0];
    }
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
        NSManagedObject *objectToDelete = [self.exerciseTypes objectAtIndex:indexPath.row];
        [context deleteObject:objectToDelete];
        
        [self.exerciseTypes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
        NSError *error;
        if (![context save:&error]){
        }
        
        [self.tableView reloadData];
    }
    
}

-(void) grabData {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ExerciseType" inManagedObjectContext:context];
    [request setEntity:entityDesc];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"exerciseType" ascending:NO];
    NSArray *sortDescriptor = [[NSArray alloc] initWithObjects:sortDesc, nil];
    [request setSortDescriptors:sortDescriptor];
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
    }
    self.exerciseTypes = mutableFetchResult;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditExerciseTypeSegue"]){
        ABAddExerciseTypeViewController *controller = segue.destinationViewController;
        NSIndexPath *indexPath =[self.tableView indexPathForCell:sender];
        controller.exercise = [self.exerciseTypes objectAtIndex:indexPath.row];
        controller.title = @"Edit Exercise Type";
      }
    else if ([segue.identifier isEqualToString:@"AddExerciseTypeSegue"]){
        ABAddExerciseTypeViewController *controller = segue.destinationViewController;
        controller.title = @"Add Exercise Type";
    }
}

@end
