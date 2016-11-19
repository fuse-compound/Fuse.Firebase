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

		public iOSGADBannerView() : base(Create()) { }

		[Foreign(Language.ObjC)]
		static ObjC.Object Create()
        @{
            GADRequest *request = [GADRequest request];
            request.testDevices = [NSArray arrayWithObjects:kGADSimulatorID, nil];

            GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
            bannerView.adUnitID = @"ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx";
            bannerView.rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            // bannerView.delegate = (id<GADBannerViewDelegate>)self;

            [bannerView loadRequest:request];
            return bannerView;
		@}

	}
}
