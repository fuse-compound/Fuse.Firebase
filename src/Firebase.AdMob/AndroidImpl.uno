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
            // MobileAds.initialize(getApplicationContext(), "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx");
        }

		public AndroidGADBannerView() : base(Create())
        {
        }

		[Foreign(Language.Java)]
		static Java.Object Create()
        @{
            // http://stackoverflow.com/questions/15953075/how-to-create-an-admob-banner-programatically
            AdView adView = new AdView(@(Activity.Package).@(Activity.Name).GetRootActivity());
            adView.setAdSize(AdSize.FLUID);
            adView.setAdUnitId("ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx");

            // Initiate a generic request to load it with an ad
            AdRequest adRequest = new AdRequest.Builder().addTestDevice("648F2582C7B37F0EBEB4DA80843A5583").build();
            adView.loadAd(adRequest);

            return adView;
		@}

	}
}
