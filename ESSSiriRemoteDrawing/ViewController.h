//
//  ViewController.h
//  ESSSiriRemoteDrawing
//
//  Created by Matthias Gansrigler on 02.07.2021.
//

#import <Cocoa/Cocoa.h>
#import "ESSSiriRemoteView.h"

@interface ViewController : NSViewController

@property (strong) IBOutlet ESSSiriRemoteView *remoteView;
@property (strong) IBOutlet NSPopUpButton *selectionButton;

- (IBAction)selectRemoteType:(id)sender;

@end

