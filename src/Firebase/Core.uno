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
    [ForeignInclude(Language.Java, "java.util.ArrayList", "java.util.List", "android.graphics.Color")]
    [Require("Gradle.Dependency.ClassPath", "com.google.gms:google-services:3.0.0")]
    [Require("Gradle.Dependency.Compile", "com.google.firebase:firebase-core:9.2.0")]
    [Require("Gradle.BuildFile.End", "apply plugin: 'com.google.gms.google-services'")]

    [Require("Cocoapods.Podfile.Target", "pod 'Firebase/Core'")]
    [Require("Cocoapods.Podfile.Target", "pod 'FirebaseAnalytics'")]
    [extern(iOS) Require("Source.Include", "Firebase/Firebase.h")]
    public class Core
    {
        static bool _initialized;

        public static void Init()
        {
            if (!_initialized)
            {
                InitImpl();
                _initialized = true;
            }
        }
        extern(!mobile)
        static public void InitImpl() { }

        [Foreign(Language.ObjC)]
        extern(iOS)
        static public void InitImpl()
        @{
            [FIRApp configure];
        @}

        [Foreign(Language.Java)]
        extern(Android)
        static public void InitImpl()
        @{
        @}
    }
}
