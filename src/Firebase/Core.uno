using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Triggers;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.Android;

namespace Firebase
{
    extern(!mobile)
    public class Core
    {
        static public void Init() { }
    }

    [Require("Cocoapods.Podfile.Target", "pod 'Firebase/Core'")]
    [Require("Cocoapods.Podfile.Target", "pod 'FirebaseAnalytics'")]
    [Require("Source.Include", "Firebase/Firebase.h")]
    extern(iOS)
    public class Core
    {
        [Foreign(Language.ObjC)]
        static public void Init()
        @{
            [FIRApp configure];
        @}
    }

    [ForeignInclude(Language.Java, "java.util.ArrayList", "java.util.List", "android.graphics.Color")]
    [Require("Gradle.Dependency.ClassPath", "com.google.gms:google-services:3.0.0")]
    [Require("Gradle.Dependency.Compile", "com.google.firebase:firebase-core:9.2.0")]
    [Require("Gradle.BuildFile.End", "apply plugin: 'com.google.gms.google-services'")]
	extern(Android)
    public class Core
    {
		[Foreign(Language.Java)]
		static public void Init()
		@{
		@}
	}
}
