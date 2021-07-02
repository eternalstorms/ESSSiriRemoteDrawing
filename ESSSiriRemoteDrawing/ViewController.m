//
//  ViewController.m
//  ESSSiriRemoteDrawing
//
//  Created by Matthias Gansrigler on 02.07.2021.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (IBAction)selectRemoteType:(id)sender
{
	self.remoteView.remoteType = (ESSAppleTVSiriRemoteType)self.selectionButton.selectedTag;
}

@end
