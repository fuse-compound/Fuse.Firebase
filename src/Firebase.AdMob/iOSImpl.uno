using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Triggers;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.iOS;
using Uno.Threading;
using Firebase.AdMob;

namespace Firebase.AdMob
{
    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "GoogleMobileAds/GADBannerView.h")]
    [Require("Source.Include", "@{AdMobService:Include}")]
    extern(iOS)
    public class iOSGADBannerView : LeafView
	{
        static iOSGADBannerView()
        {
            AdMobService.Init();
        }

        /*
        https://firebase.google.com/docs/admob/ios/quick-start

        - (BOOL)application:(UIApplication *)application
            didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

          // Use Firebase library to configure APIs
          [FIRApp configure];
          [GADMobileAds configureWithApplicationID:@"ca-app-pub-3940256099942544~1458002511"];
          return YES;
        }

        Initializing the Google Mobile Ads SDK at app launch allows the SDK to fetch app-level settings and perform configuration tasks as early as possible. This can help reduce latency for the initial ad request. Initialization requires an app ID. App IDs are unique identifiers given to mobile apps when they're registered in the AdMob console.


 
        */

		public iOSGADBannerView(string adunit) : base(Create(adunit)) { }

		[Foreign(Language.ObjC)]
		static ObjC.Object Create(string adunit)
        @{
            GADRequest *request = [GADRequest request];
            request.testDevices = [NSArray arrayWithObjects:kGADSimulatorID,
#if @(Project.AdMob.TestDevices:IsSet)
                @(Project.AdMob.TestDevices:Join('\n                ', '@"','",'))
#endif
                nil
            ];

            GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
            bannerView.adUnitID = adunit;
            bannerView.rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            // No delegate yet
            // bannerView.delegate = (id<GADBannerViewDelegate>)self;

            [bannerView loadRequest:request];
            return bannerView;
		@}

	}
}
