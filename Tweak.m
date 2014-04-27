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
                NSString *sizeString = [[(UITableViewCell *)[self tableView:view cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]] detailTextLabel] text];
                float size = [sizeString floatValue];
                NSInteger length = [sizeString length];
                if (length > 2)
                    switch ([sizeString characterAtIndex:length - 2]) {
                        case 'M':
                            size *= 1024;
                            break;
                        case 'G':
                            size *= 1024 * 1024;
                            break;
                        case 'T':
                            size *= 1024 * 1024 * 1024;
                    }
                [data addObject:[[Entry alloc] initWithIndex:i data:@(size)]];
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

%end
