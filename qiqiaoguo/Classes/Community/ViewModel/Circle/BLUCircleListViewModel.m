//
//  BLUCircleListViewModel.m
//  Blue
//
//  Created by Bowen on 24/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCircleListViewModel.h"
#import "BLUCircle.h"
#import "BLUCircleMO.h"
#import "BLUApiManager+Circle.h"

@interface BLUCircleListViewModel ()

@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign, readwrite) BLUCircleListViewModelState state;

@property (nonatomic, strong) BLUPagination *pagination;
@property (nonatomic, weak) id <NSFetchedResultsControllerDelegate> fetchedResultsControllerDelegate;
@property (nonatomic, weak) RACDisposable *fetchDisposable;

@property (nonatomic, assign) NSInteger currentUserID;

@end

@implementation BLUCircleListViewModel

- (instancetype)initWithFetchedResultsControllerDelegate:(id<NSFetchedResultsControllerDelegate>)delegate {
    if (self = [super init]) {
        _fetchedResultsControllerDelegate = delegate;
        _state = BLUCircleListViewModelStateNormal;
        _currentUserID = 0;
    }
    return self;
}

- (BLUPagination *)pagination {
    if (_pagination == nil) {
        _pagination =
        [[BLUPagination alloc]
         initWithPerpage:BLUPaginationPerpageMax
         group:nil
         order:BLUPaginationOrderNone];
    }
    return _pagination;
}

- (RACSignal *)fetch {
    NSInteger currentUserID;
    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    if (currentUser) {
        currentUserID = currentUser.userID;
    } else {
        currentUserID = 0;
    }

    if (self.currentUserID != currentUserID) {
        self.fetchedResultsController.fetchRequest.predicate = [self circleListPredicate];
        NSError *error;
        if (![self.fetchedResultsController performFetch:&error]) {
            BLULogError(@"Error = %@", error);
#ifdef BLUDebug
            abort();
#endif
        }
    }


    self.state = BLUCircleListViewModelStateFetcing;
    @weakify(self);
    if (currentUser) {
        return [[[[BLUApiManager sharedManager] fetchFollowedCircles:self.pagination] doNext:^(NSArray *items) {
            @strongify(self);
            self.state = BLUCircleListViewModelStateNormal;
            [self resetFollowStateWithMasterUserID:currentUserID];
            [self generateCircleMOWithCircles:items];
            [self removeUnfollowedCircleWithMasterUserID:currentUserID];

            [[[BLUApiManager sharedManager] fetchRecommendedCircles:self.pagination] subscribeNext:^(NSArray *items) {
                @strongify(self);
                self.state = BLUCircleListViewModelStateNormal;
                [self removeUnfollowedCircleWithMasterUserID:currentUserID];
                [self generateCircleMOWithCircles:items];
            } error:^(NSError *error) {
                @strongify(self);
//                NSLog(@"Error = %@", error);
                self.state = BLUCircleListViewModelStateFailed;
            }];
        }] doError:^(NSError *error) {
            @strongify(self);
//            NSLog(@"Error = %@", error);
            self.state = BLUCircleListViewModelStateFailed;
        }];
    } else {
        return [[[[BLUApiManager sharedManager] fetchRecommendedCircles:self.pagination] doNext:^(NSArray *items) {
            @strongify(self);
            self.state = BLUCircleListViewModelStateNormal;
            [self removeUnfollowedCircleWithMasterUserID:currentUserID];
            [self generateCircleMOWithCircles:items];
         
        }] doError:^(NSError *error) {
            @strongify(self);
            BLULogError(@"Error = %@", error);
            self.state = BLUCircleListViewModelStateFailed;
        }];
    }
}

- (RACSignal *)fetchFollowedCircles {
    NSInteger currentUserID = [self getCurrentUserID];
    [self refreshFetchRequestForFetchResultsControllerWithCurrentUserID:currentUserID];

    if (currentUserID != 0) {
        @weakify(self);
        self.state = BLUCircleListViewModelStateFetcing;
        return [[[[BLUApiManager sharedManager] fetchFollowedCircles:self.pagination] doNext:^(NSArray *items) {
            @strongify(self);
            self.state = BLUCircleListViewModelStateNormal;
            [self resetFollowStateWithMasterUserID:currentUserID];
            [self generateCircleMOWithCircles:items];
        }] doError:^(NSError *error) {
            @strongify(self);
            self.state = BLUCircleListViewModelStateFailed;
        }];
    } else {
        self.state = BLUCircleListViewModelStateNormal;
        return [RACSignal empty];
    }
}

- (RACSignal *)fetchRecommendedCircles {
    NSInteger currentUserID = [self getCurrentUserID];
    [self refreshFetchRequestForFetchResultsControllerWithCurrentUserID:currentUserID];

    [self removeUnfollowedCircleWithMasterUserID:currentUserID];

    @weakify(self);
    return [[[[BLUApiManager sharedManager] fetchRecommendedCircles:self.pagination] doNext:^(NSArray *items) {
        @strongify(self);
        self.state = BLUCircleListViewModelStateNormal;
        [self generateCircleMOWithCircles:items];
    }] doError:^(NSError *error) {
        @strongify(self);
        self.state = BLUCircleListViewModelStateFailed;
    }];
}

- (NSInteger)getCurrentUserID {
    NSInteger currentUserID;
    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    if (currentUser) {
        currentUserID = currentUser.userID;
    } else {
        currentUserID = 0;
    }
    return currentUserID;
}

- (void)refreshFetchRequestForFetchResultsControllerWithCurrentUserID:(NSInteger)currentUserID {
    if (self.currentUserID != currentUserID) {
        self.fetchedResultsController.fetchRequest.predicate = [self circleListPredicate];
        NSError *error;
        if (![self.fetchedResultsController performFetch:&error]) {
            BLULogError(@"Error = %@", error);
#ifdef BLUDebug
            abort();
#endif
        }
    }
}

- (void)generateCircleMOWithCircles:(NSArray *)circles {
    if (circles.count > 0) {
        BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
        NSInteger masterUserID = currentUser != nil ? currentUser.userID : 0;
        [circles enumerateObjectsUsingBlock:^(BLUCircle *circle, NSUInteger idx, BOOL * _Nonnull stop) {
            BLUCircleMO *circleMO = [BLUCircleMO MR_findFirstWithPredicate:[self circlePredicateWithUserID:masterUserID circleID:circle.circleID] sortedBy:BLUCircleMOKeyCircleID ascending:NO];

            if (circleMO == nil) {
                circleMO = [BLUCircleMO MR_createEntity];
            }
            
            [circleMO configCircleMOWithCircle:circle];
            circleMO.masterUserID = @(masterUserID);
        }];
    }
}

- (void)removeUnfollowedCircleWithMasterUserID:(NSInteger)masterUserID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"masterUserID == %@ && didFollowCircle == NO", @(masterUserID)];
    NSArray *circleMOs = [BLUCircleMO MR_findAllWithPredicate:predicate];
    for (BLUCircleMO *circleMO in circleMOs) {
        [circleMO MR_deleteEntity];
    }
}

- (void)resetFollowStateWithMasterUserID:(NSInteger)masterUserID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"masterUserID == %@", @(masterUserID)];
    NSArray *circleMOs = [BLUCircleMO MR_findAllWithPredicate:predicate];
    for (BLUCircleMO *circleMO in circleMOs) {
        circleMO.didFollowCircle = @(NO);
    }
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController == nil) {
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        _fetchedResultsController = [BLUCircleMO MR_fetchAllGroupedBy:BLUCircleMOKeyDidFollowCircle
                                                        withPredicate:[self circleListPredicate]
                                                             sortedBy:[NSString stringWithFormat:@"%@,%@", BLUCircleMOKeyDidFollowCircle, BLUCircleMOKeyPriority]
                                                            ascending:NO
                                                             delegate:_fetchedResultsControllerDelegate
                                                            inContext:context];
        NSError *error = nil;
        if (![_fetchedResultsController performFetch:&error]) {
#ifdef BLUDebug
            abort();
#endif
            BLULogError(@"Error = %@", error);
        }
    }
    return _fetchedResultsController;
}

- (NSFetchRequest *)circleListFetchRequestWithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest =
    [BLUCircleMO MR_requestAllSortedBy:[NSString stringWithFormat:@"%@,%@", BLUCircleMOKeyDidFollowCircle, BLUCircleMOKeyPriority] ascending:NO withPredicate:[self circleListPredicate]];
    return fetchRequest;
}

- (NSPredicate *)circleListPredicate {
    NSInteger userID = 0;
    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    if (currentUser) {
        userID = currentUser.userID;
    }
    self.currentUserID = userID;
    return [NSPredicate predicateWithFormat:@"masterUserID == %@", @(userID)];
}

- (NSPredicate *)circlePredicateWithUserID:(NSInteger)userID circleID:(NSInteger)circleID {
    return [NSPredicate predicateWithFormat:@"masterUserID == %@ && circleID == %@", @(userID), @(circleID)];
}

@end
