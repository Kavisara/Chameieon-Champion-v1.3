

#import "MKStoreManager.h"
#import "NinjaFishingAppDelegate.h"
//#import "globals.h"
#import "GameConfig.h"

@implementation MKStoreManager

@synthesize purchasableObjects;
@synthesize storeObserver;

// all your features should be managed one and only by StoreManager

static NSString *featureAId = @"com.topfreekidsgamesplus.candyfishandfatkidslice.buy1000g";
static NSString *featureBId = @"com.topfreekidsgamesplus.candyfishandfatkidslice.buy5000g";
static NSString *featureCId = @"com.topfreekidsgamesplus.candyfishandfatkidslice.buy10000";
static NSString *featureDId = @"com.topfreekidsgamesplus.candyfishandfatkidslice.buy10000";
static NSString *featureEId = @"com.topfreekidsgamesplus.candyfishandfatkidslice.buy25000";
static NSString *featureRemAllId = @"com.topfreekidsgamesplus.candyfishandfatkidslice.unlockall";

BOOL featureAPurchased = NO;
BOOL featureBPurchased = NO;
BOOL featureCPurchased = NO;
BOOL featureDPurchased = NO;
BOOL featureEPurchased = NO;
BOOL featureRemAllIdPurchased = NO;

static MKStoreManager* _sharedStoreManager; // self

- (void)dealloc
{
	[_sharedStoreManager release];
	[storeObserver release];
	[super dealloc];
}

+ (BOOL) featureAPurchased {
	return featureAPurchased;
}

+ (BOOL) featureBPurchased {
	return featureBPurchased;
}

+ (MKStoreManager*)sharedManager
{
	@synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            [[self alloc] init]; // assignment not done here
			_sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];
			[_sharedStoreManager requestProductData];
			
			[MKStoreManager loadPurchases];
			_sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    
    return _sharedStoreManager;
}

#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_sharedStoreManager == nil)
        {
            _sharedStoreManager = [super allocWithZone:zone];
            return _sharedStoreManager;  // assignment and return on first allocation
        }
    }
    
    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}


- (void) requestProductData
{
	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:
								 [NSSet setWithObjects: featureAId, featureBId, featureCId, featureDId, nil]]; // add any other product here
	request.delegate = self;
	[request start];
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	[purchasableObjects addObjectsFromArray:response.products];
	// populate your UI Controls here
	for(int i=0;i<[purchasableObjects count];i++)
	{
		
		SKProduct *product = [purchasableObjects objectAtIndex:i];
		NSLog(@"Feature: %@, Cost: %f, ID: %@",[product localizedTitle],
			  [[product price] doubleValue], [product productIdentifier]);
	}
	
	[request autorelease];
}

- (void) buyFeature:(NSString*) featureId
{
	if ([SKPaymentQueue canMakePayments])
	{
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"fat boy" message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

-(void) buyUnloadAll
{
    [self buyFeature:featureRemAllId];
}

- (void) buyFeatureA
{
	[self buyFeature:featureAId];
}

- (void) buyFeatureB
{
	[self buyFeature:featureBId];
}

- (void) buyFeatureC
{
	[self buyFeature:featureCId];
}

- (void) buyFeatureD
{
	[self buyFeature:featureDId];
}

- (void) buyFeatureE
{
    [self buyFeature:featureEId];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

-(void) provideContent: (NSString*) productIdentifier
{
	if([productIdentifier isEqualToString:featureAId])
    {
		featureAPurchased = YES;
        
        g_UserInfo.nMoney +=1000;
    }
    if([productIdentifier isEqualToString:featureBId])
    {
        g_UserInfo.nMoney +=5000;
    }
    if([productIdentifier isEqualToString:featureCId])
    {
        g_UserInfo.nMoney +=10000;
    }
    if([productIdentifier isEqualToString:featureDId])
    {
        g_UserInfo.nMoney +=25000;
    }
	if([productIdentifier isEqualToString:featureEId])
    {
        g_UserInfo.nMoney +=100000;
    }
    
    if([productIdentifier isEqualToString:featureRemAllId])
    {
        for(int i =0 ;i<SHOPITEM_COUNT; i++)
            g_ITEMSTATE[i] = SOLD;
        g_UserInfo.nMaxDepth = 800;
        g_UserInfo.nBlade = 20;
        g_UserInfo.nWeight = 490;
        g_UserInfo.nHook = 50;
        g_UserInfo.nFuel = 200;
        
        featureRemAllIdPurchased = YES;
    }
    
	[MKStoreManager updatePurchases];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"In-App Upgrade" message:@"Successfully Purchased" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

+(void) loadPurchases
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
	featureAPurchased = [userDefaults boolForKey:featureAId];
	featureBPurchased = [userDefaults boolForKey:featureBId];
	featureCPurchased = [userDefaults boolForKey:featureCId];
	featureDPurchased = [userDefaults boolForKey:featureDId];
	featureEPurchased = [userDefaults boolForKey:featureEId];
    featureRemAllIdPurchased = [userDefaults boolForKey:featureRemAllId];
}

+(void) updatePurchases
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
	[userDefaults setBool:featureAPurchased forKey:featureAId];
	[userDefaults setBool:featureBPurchased forKey:featureBId];
	[userDefaults setBool:featureCPurchased forKey:featureCId];
	[userDefaults setBool:featureDPurchased forKey:featureDId];
	[userDefaults setBool:featureEPurchased forKey:featureEId];
	[userDefaults setBool:featureRemAllIdPurchased forKey:featureRemAllId];
}

+(void) makePaidVersion
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:YES forKey:featureAId];
    
    [MKStoreManager loadPurchases];
}

+(void) make10Persion
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:YES forKey:featureBId];
    
    [MKStoreManager loadPurchases];
}

-(void)restoreFunc
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
}
- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        
        if([productID isEqualToString:featureRemAllId])
        {
            for(int i =0 ;i<SHOPITEM_COUNT; i++)
                g_ITEMSTATE[i] = SOLD;
            g_UserInfo.nMaxDepth = 800;
            g_UserInfo.nBlade = 20;
            g_UserInfo.nWeight = 490;
            g_UserInfo.nHook = 50;
            g_UserInfo.nFuel = 200;
            
            featureRemAllIdPurchased = YES;
        }
    }
}

@end
