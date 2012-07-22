//
//  MasterViewController.m
//  TeaAnytime
//
//  Created by Kode Charlie on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "TBXML.h"
#import "Tea.h"
#import "TeaCell.h"

@interface MasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // When the app is fired up the first time, the data store is empty.  Check for that condition,
    // and populate the data store accordingly.  Since the fetchedResults controller uses a cache,
    // we do not have to re-fetch after populating the data store for the first time.
    
    if ([[self.fetchedResultsController fetchedObjects] count] <= 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TeaAnytime" ofType:@"xml"];
        NSString *xml = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
        
        NSError *error = nil;
        TBXML *tbxml = [TBXML tbxmlWithXMLString:xml error:&error];
        if (error != nil) {
            NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
        } else {
            // Parse teas.
            TBXMLElement *teaElt = [TBXML childElementNamed:@"Tea" parentElement:tbxml.rootXMLElement];
            while (teaElt != nil) {
                // Name.
                TBXMLElement *nameElt = [TBXML childElementNamed:@"Name" parentElement:teaElt];
                NSString *name = [TBXML textForElement:nameElt];
                
                // Group.
                TBXMLElement *groupElt = [TBXML childElementNamed:@"Group" parentElement:teaElt];
                NSString *group = [TBXML textForElement:groupElt];
                
                // Group.
                TBXMLElement *imageFileNameElt = [TBXML childElementNamed:@"ImageFileName" parentElement:teaElt];
                NSString *imageFileName = [TBXML textForElement:imageFileNameElt];
                
                // Description.
                TBXMLElement *descriptionElt = [TBXML childElementNamed:@"Description" parentElement:teaElt];
                NSString *description = [TBXML textForElement:descriptionElt];
                
                Tea *curTea = (Tea *)[NSEntityDescription insertNewObjectForEntityForName:@"Tea"
                                                                   inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
                [curTea setName:name];
                [curTea setGroup:group];
                [curTea setImageFileName:imageFileName];
                [curTea setDesc:description];
                [curTea setRating:0]; // 0 means tea not yet rated.
                
                teaElt = [TBXML nextSiblingNamed:@"Tea" searchFromElement:teaElt];
            }
            
            NSError *error;
            if (![self.fetchedResultsController.managedObjectContext save:&error]) {
                // XXX Handle the error.
            }
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeaCell"];
    if (cell == nil) {
        cell = [[TeaCell alloc] init];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setIncludesPendingChanges:YES];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tea" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:50];

    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];

    [fetchRequest setSortDescriptors:sortDescriptors];

    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext 
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:@"TeaAnytimeCache"];

    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];

    TeaCell *teaCell = (TeaCell *)cell;
    [[teaCell name] setText:[[object valueForKey:@"name"] description]];
    [[teaCell group] setText:[[object valueForKey:@"group"] description]];

    NSNumber *rating = (NSNumber *)[object valueForKey:@"rating"];
    if ([rating intValue] > 0) {
        [[teaCell rating] setText:[NSString stringWithFormat:@"%d", [rating intValue]]];
    } else {
        [[teaCell rating] setText:@""];
    }

    NSString *imageFileName = [[object valueForKey:@"imageFileName"] description];
    [[teaCell leavesImage] setImage:[UIImage imageNamed:imageFileName]];
}

@end
