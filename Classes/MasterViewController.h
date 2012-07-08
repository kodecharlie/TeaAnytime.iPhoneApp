//
//  MasterViewController.h
//  TeaAnytime
//
//  Created by Kode Charlie on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
    UIBarButtonItem *infoBarButton;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *infoBarButton;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
