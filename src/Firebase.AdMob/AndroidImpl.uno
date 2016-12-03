using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Triggers;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.Android;
using Uno.Threading;
using Firebase.AdMob;

// TODO:
//  pause, resume, destroy for adview

namespace Firebase.AdMob
{

    [Require("Gradle.Dependency.Compile", "com.google.firebase:firebase-ads:9.2.0")]
    [ForeignInclude(Language.Java,
                    "com.google.android.gms.ads.AdRequest",
                    "com.google.android.gms.ads.AdSize",
                    "com.google.android.gms.ads.AdView")]
    extern(android)
    public class AndroidGADBannerView : LeafView
	{
        static AndroidGADBannerView()
        {
            AdMobService.Init();
            // Initializing the Google Mobile Ads SDK at app launch allows the SDK to fetch app-level settings and perform configuration tasks as early as possible. This can help reduce latency for the initial ad request. Initialization requires an app ID. App IDs are unique identifiers given to mobile apps when they're registered in the AdMob console.
            // MobileAds.initialize(getApplicationContext(), "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx");
        }

		public AndroidGADBannerView(string adunit) : base(Create(adunit))
        {
        }

		[Foreign(Language.Java)]
		static Java.Object Create(string adunit)
        @{
            // http://stackoverflow.com/questions/15953075/how-to-create-an-admob-banner-programatically
            AdView adView = new AdView(@(Activity.Package).@(Activity.Name).GetRootActivity());
            adView.setAdSize(AdSize.FLUID);
            adView.setAdUnitId(adunit);

            // Initiate a generic request to load it with an ad
            AdRequest adRequest = new AdRequest.Builder()
#if @(Project.AdMob.TestDevices:IsSet)
                @(Project.AdMob.TestDevices:Join('\n                ', '.addTestDevice("','")'))
#endif
                .build();
            adView.loadAd(adRequest);

            return adView;
		@}

	}
}
