#import "Entry.h"

@interface PSSpecifier
@property(strong, nonatomic) NSString *identifier;
@end

@interface PSListController
- (PSSpecifier *)specifier;
- (NSInteger)numberOfSectionsInTableView:(id)view;
- (id)tableView:(id)view cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface PSSubtitleSwitchTableCell
@end
