#import "Tweak.h"

%hook PSListController

NSArray *map;
NSInteger count = 0;

- (NSInteger)tableView:(id)view numberOfRowsInSection:(NSInteger)section {
    NSInteger result = %orig(view, section);
    if ([[self specifier].identifier isEqualToString:@"MOBILE_DATA_SETTINGS_ID"] && section == [self numberOfSectionsInTableView:view] - 2) {
        count = 0;
        if (result > 1) {
            NSInteger num;
            if ([[self tableView:view cellForRowAtIndexPath:[NSIndexPath indexPathForRow:result - 2 inSection:section]] isKindOfClass:[%c(PSSubtitleSwitchTableCell) class]])
                num = result - 1;
            else
                num = result - 2;
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:num];
            for (NSInteger i = 0; i < num; i++) {
                NSString *size = [[(UITableViewCell *)[self tableView:view cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]] detailTextLabel] text];
                NSArray *parts = [size componentsSeparatedByString:@" "];
                if ([parts count] == 2)
                    [data addObject:[[Entry alloc] initWithIndex:i data:@([parts[0] floatValue] * [@{@"KB": @1, @"MB": @1000, @"GB": @1000000, @"TB": @1000000000}[parts[1]] intValue])]];
                else
                    [data addObject:[[Entry alloc] initWithIndex:i data:@0]];
            }
            map = [data sortedArrayUsingComparator:^NSComparisonResult(Entry *a, Entry *b) {
                return [b.data compare: a.data];
            }];
            count = num;
        }
    }
    return result;
}

- (id)tableView:(id)view cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < count && [[self specifier].identifier isEqualToString:@"MOBILE_DATA_SETTINGS_ID"] && indexPath.section == [self numberOfSectionsInTableView:view] - 2)
        return %orig(view, [NSIndexPath indexPathForRow:((Entry *)map[indexPath.row]).index inSection:indexPath.section]);
    else
        return %orig(view, indexPath);
}

- (void)viewWillDisappear:(BOOL)animated {
    %orig(animated);
    map = nil;
    count = 0;
}

%end
