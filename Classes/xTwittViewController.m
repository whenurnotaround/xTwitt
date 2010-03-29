//
//  xTwittViewController.m
//  xTwitt
//
//  Created by Yongpisanpop Papon on 2/21/10.
//  Copyright NAIST 2010. All rights reserved.
//

#import "xTwittViewController.h"

@implementation xTwittViewController

@synthesize username;
@synthesize password;
@synthesize table;
@synthesize listData;

-(IBAction)login {
	NSLog(@"login with username %@ and password %@", username.text, password.text);
	
	NSLog(@"username = %@", username.text);
	
	twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:self];
    [twitterEngine setUsername:username.text password:password.text];
	
	//NSLog(@"getPublicTimelineSinceID: connectionIdentifier = %@", [twitterEngine getPublicTimeline]);
	//NSLog(@"getUserTimelineFor: connectionIdentifier = %@", [twitterEngine getFollowedTimelineSinceID:0 startingAtPage:0 count:20]);
	
}

#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"table has %i rows", [self.listData count]);
	return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellTableIdentifier = @"CellTableIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier] autorelease];
		
	}
	
	NSUInteger row = [indexPath row];
	NSString *image_path = [[[self.listData objectAtIndex:row] objectForKey:@"user"] objectForKey:@"profile_image_url"];
	
	NSURL *url = [NSURL URLWithString:image_path];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *image = [[UIImage alloc] initWithData:data];
	cell.imageView.image = image;
	cell.textLabel.text = [[[self.listData objectAtIndex:row] objectForKey:@"user"] objectForKey:@"name"];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
	cell.detailTextLabel.text = [[self.listData objectAtIndex:row] objectForKey:@"text"];
	
	return cell;
																							
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	
	if (row == 0) {
		return nil;
	}
	
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	NSString *message = [[self.listData objectAtIndex:row] objectForKey:@"text"];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[self.listData objectAtIndex:row] objectForKey:@"user"] objectForKey:@"name"] message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alert show];
	
	[message release];
	[alert release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

#pragma mark system

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"Start xTwitt");
	
	twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:self];
    [twitterEngine setUsername:@"whenurnotaround" password:@"redpig6"];
	NSLog(@"getUserTimelineFor: connectionIdentifier = %@", [twitterEngine getFollowedTimelineSinceID:0 startingAtPage:0 count:20]);

	
	
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.listData = nil;
}


- (void)dealloc {
	[listData release];
    [twitterEngine release];
	[super dealloc];
	
}

#pragma mark MGTwitterEngineDelegate methods


- (void)requestSucceeded:(NSString *)connectionIdentifier
{
    NSLog(@"Request succeeded for connectionIdentifier = %@", connectionIdentifier);
}


- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
    NSLog(@"Request failed for connectionIdentifier = %@, error = %@ (%@)", 
          connectionIdentifier, 
          [error localizedDescription], 
          [error userInfo]);
}


- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got statuses for %@:\r%@", connectionIdentifier, [statuses objectAtIndex:2]);
	
	self.listData = statuses;
	NSLog(@">>> %i", [self.listData count]);
	[table reloadData];
	
	
}


- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got direct messages for %@:\r%@", connectionIdentifier, messages);
}


- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got user info for %@:\r%@", connectionIdentifier, userInfo);
}


- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Got misc info for %@:\r%@", connectionIdentifier, miscInfo);
}

- (void)searchResultsReceived:(NSArray *)searchResults forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Got search results for %@:\r%@", connectionIdentifier, searchResults);
}


- (void)imageReceived:(UIImage *)image forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got an image for %@: %@", connectionIdentifier, image);
    
    // Save image to the Desktop.
    NSString *path = [[NSString stringWithFormat:@"~/Desktop/%@.tiff", connectionIdentifier] stringByExpandingTildeInPath];
    [[image TIFFRepresentation] writeToFile:path atomically:NO];
}

- (void)connectionFinished:(NSString *)connectionIdentifier
{
    NSLog(@"Connection finished %@", connectionIdentifier);
	
	if ([twitterEngine numberOfConnections] == 0)
	{
		//[NSApp terminate:self];
	}
}

#if YAJL_AVAILABLE

- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got an object for %@: %@", connectionIdentifier, dictionary);
}

#endif

@end
