//
//  BLUDialogueViewController.m
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUDialogueViewController.h"
#import "BLUDialogueViewModel.h"
#import "BLUDialogueCell.h"
#import "BLUChatViewController.h"
#import "BLUDialogue.h"
#import "BLUDialogueMO.h"
#import "BLURemoteNotification.h"
#import <AudioToolbox/AudioServices.h>

@interface BLUDialogueViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) BLUDialogueViewModel *dialogueViewModel;
@property (nonatomic, strong) BLUTableView *tableView;
@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;

@end

@implementation BLUDialogueViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"dialogue-vc.title", @"");
        self.hidesBottomBarWhenPushed = YES;
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;

    _tableView = [BLUTableView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
    [_tableView registerClass:[BLUDialogueCell class] forCellReuseIdentifier:NSStringFromClass([BLUDialogueCell class])];
    [self.view addSubview:_tableView];

//    @weakify(self);
//    [RACObserve(self, dialogueViewModel.state) subscribeNext:^(NSNumber *state) {
//        @strongify(self);
//        switch (state.integerValue) {
//            case BLUDialogueViewModelStateFetching:
//            case BLUDialogueViewModelStateNormal: {
//                self.title = NSLocalizedString(@"dialogue-vc.normal", @"Dialogue");
//            } break;
////                self.title= NSLocalizedString(@"dialogue-vc.title.fetching", @"Fetching");
////            } break;
//            case BLUDialogueViewModelStateFetchAgain: {
//                self.title = NSLocalizedString(@"dialogue-vc.title.fetch-again", @"Fetch again");
//            } break;
//            case BLUDialogueViewModelStateFetchFailed: {
//                self.title = NSLocalizedString(@"dialogue-vc.title.fetch-failed", @"Fetch failed");
//            } break;
//        }
//    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([BLUAppManager sharedManager].currentUser) {
        [self.dialogueViewModel fetch];
    }
}

- (void)handleRemoteNotification:(NSNotification *)userInfo {
    BLURemoteNotification *remoteNotification = userInfo.object;
    if (remoteNotification.type == BLURemoteNotificationTypePrivateMessage) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        [self.dialogueViewModel fetch];
    } else {
        [super handleRemoteNotification:userInfo];
    }
}

#pragma mark - Model.

- (BLUDialogueViewModel *)dialogueViewModel {
    if (_dialogueViewModel == nil) {
        _dialogueViewModel = [[BLUDialogueViewModel alloc] initWithFetchedResultsControllerDelegate:self];
    }
    return _dialogueViewModel;
}

- (NSFetchedResultsController *)fetchedResultsController {
    return self.dialogueViewModel.fetchedResultsController;
}

#pragma mark - UITableView.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUDialogueCell *cell = (BLUDialogueCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUDialogueCell class]) forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [self.tableView sizeForCellWithCellClass:[BLUDialogueCell class] cacheByIndexPath:indexPath width:self.tableView.width configuration:^(BLUCell *cell) {
        [self configCell:cell atIndexPath:indexPath];
    }];
    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLUDialogueMO *dialogueMO = [self.fetchedResultsController objectAtIndexPath:indexPath];
    BLUChatViewController *vc = [[BLUChatViewController alloc] initWithUser:dialogueMO.fromUser];
    [self pushViewController:vc];
    dialogueMO.unreadCount = @(0);
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
//        if (error) {
//            NSLog(@"Save error = %@", error);
//        } else {
//            BLULogDebug(@"context did save.");
//        }
//    }];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUDialogueMO *dialogueMO = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.dialogueViewModel deleteDialogue:dialogueMO];
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    BLUDialogueCell *dialogueCell = (BLUDialogueCell *)cell;
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    [dialogueCell setModel:[self.fetchedResultsController objectAtIndexPath:indexPath] showSolidLine:indexPath.row != [sectionInfo numberOfObjects] - 1];
}

#pragma mark - NSFetchResultController.

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configCell:[[self tableView] cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    UITableView *tableView = self.tableView;

    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        } break;
        case NSFetchedResultsChangeDelete: {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        } break;
        default: break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

@end
