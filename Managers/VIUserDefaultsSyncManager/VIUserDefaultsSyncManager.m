//
//  VIUserDefaults.m
//  21
//
//  Created by Nils Fischer on 21.11.13.
//
//

#import "VIUserDefaultsSyncManager.h"

@implementation VIUserDefaultsSyncManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSyncEnabled:(BOOL)syncEnabled {
    if (_syncEnabled!=syncEnabled) {
        _syncEnabled = syncEnabled;

        if (_syncEnabled) {

            // Register for NSUserDefaults changes
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localStoreDidChange:) name:NSUserDefaultsDidChangeNotification object:[NSUserDefaults standardUserDefaults]];

            // Register for iCloud Key-Value Store changes
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cloudStoreDidChange:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:[NSUbiquitousKeyValueStore defaultStore]];
            [[NSUbiquitousKeyValueStore defaultStore] synchronize];

            [self.logger log:@"Enabled User Defaults Cloud Sync" forLevel:VILogLevelInfo];

        } else {

            [[NSNotificationCenter defaultCenter] removeObserver:self];

            [self.logger log:@"Disabled User Defaults Cloud Sync" forLevel:VILogLevelInfo];

        }
    }
}

- (void)localStoreDidChange:(NSNotification *)notification {

    // update cloud store
    NSDictionary *localStore = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    [localStore enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (!self.userDefaultsKeys||[self.userDefaultsKeys containsObject:key]) {
            [[NSUbiquitousKeyValueStore defaultStore] setObject:obj forKey:key];
            [self.logger log:@"Pushed local User Defaults to Cloud" object:key forLevel:VILogLevelInfo];
        }
    }];
    //[[NSUbiquitousKeyValueStore defaultStore] synchronize];

}

- (void)cloudStoreDidChange:(NSNotification *)notification {

    // prevent NSUserDefaultsDidChangeNotification from being posted
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];

    // update local store
    NSArray *changedKeys = [notification.userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
    [changedKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (!self.userDefaultsKeys||[self.userDefaultsKeys containsObject:obj]) {
            [[NSUserDefaults standardUserDefaults] setObject:[[NSUbiquitousKeyValueStore defaultStore] objectForKey:obj] forKey:obj];
            [self.logger log:@"Updated local User Defaults from Cloud" object:obj forLevel:VILogLevelInfo];
        }
    }];

    //[[NSUserDefaults standardUserDefaults] synchronize];

    // re-enable NSUserDefaultsDidChangeNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localStoreDidChange:) name:NSUserDefaultsDidChangeNotification object:[NSUserDefaults standardUserDefaults]];
}

@end