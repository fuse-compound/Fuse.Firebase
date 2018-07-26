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

namespace Firebase.Storage
{
    [ForeignInclude(Language.Java,
        "com.google.firebase.storage.FirebaseStorage",
        "com.google.firebase.storage.OnProgressListener",
        "com.google.firebase.storage.StorageReference",
        "com.google.firebase.storage.UploadTask")]
    [Require("Cocoapods.Podfile.Target", "pod 'Firebase/Storage'")]
    [Require("Gradle.Dependency.Compile", "com.google.firebase:firebase-storage:12.0.1")]
    [extern(iOS) Require("Source.Import","FirebaseStorage/FirebaseStorage.h")]
    extern(mobile)
    static class StorageService
    {
        static bool _initialized;
        extern(android) static Java.Object _handle;
        extern(ios) public static ObjC.Object _handle;

        public static void Init()
        {
            if (!_initialized)
            {
                if defined(android) AndroidInit();
                if defined(ios) iOSInit();
                _initialized = true;
            }
        }

        [Foreign(Language.ObjC)]
        extern(iOS)
        public static void iOSInit()
        @{
            [FIRStorage storage];
            @{_handle:Set([[FIRStorage storage] reference])};
        @}


        [Foreign(Language.Java)]
        extern(android)
        public static void AndroidInit()
        @{
            @{_handle:Set(FirebaseStorage.getInstance().getReference())};
        @}
    }

    extern(!mobile)
    static class StorageService
    {
        public static void Init() {}
    }

    extern(!mobile)
    internal class Upload : Promise<string>
    {
        public Upload(string storagepath, string filepath)
        {
            Reject(new Exception("Not implemented on desktop"));
        }
    }

    [Require("Entity", "StorageService")]
    [Require("Source.Include","@{StorageService:Include}")]
    [extern(iOS) Require("Source.Import","FirebaseStorage/FirebaseStorage.h")]
    extern(iOS)
    internal class Upload : Promise<string>
    {
        [Foreign(Language.ObjC)]
        public Upload(string storagepath, string filepath)
        @{
            FIRStorageReference *ref = @{StorageService._handle:Get()};
            FIRStorageReference *refChild = [ref child:storagepath];
            NSURL *localFile = [NSURL fileURLWithPath:filepath];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                FIRStorageUploadTask *uploadTask = [refChild putFile:localFile metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *errorUploading) {
                    if (errorUploading != nil) {
                        NSString *erstrupload = [NSString stringWithFormat:@"Firebase Storage Upload Error: %@", errorUploading.localizedDescription];
                        @{Upload:Of(_this).Reject(string):Call(erstrupload)};
                    } else {
                        [refChild downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                            if (error != nil) {
                                NSString *erstr = [NSString stringWithFormat:@"Firebase Storage URL Error: %@", error.localizedDescription];
                                @{Upload:Of(_this).Reject(string):Call(erstr)};
                            } else {
                                NSURL *downloadURL = URL;
                                @{Upload:Of(_this).Resolve(string):Call([downloadURL absoluteString])};
                            }
                        }];
                    }
                }];
            });
        @}
        void Reject(string reason) { Reject(new Exception(reason)); }
    }

    [ForeignInclude(Language.Java,
        "com.google.android.gms.tasks.OnFailureListener",
        "com.google.android.gms.tasks.OnSuccessListener",
        "com.google.firebase.storage.FirebaseStorage",
        "com.google.firebase.storage.OnProgressListener",
        "com.google.firebase.storage.StorageReference",
        "com.google.firebase.storage.UploadTask",
        "java.io.File",
        "android.net.Uri")]
    extern(Android)
    internal class Upload : Promise <string>
    {
        [Foreign(Language.Java)]
        public Upload(string storagepath, string filepath)
        @{
            StorageReference ref = (StorageReference)@{StorageService._handle:Get()};
            Uri file = Uri.fromFile(new File(filepath));
            StorageReference childRef = ref.child(storagepath);

            childRef.putFile(file).addOnFailureListener(new OnFailureListener() {
                @Override
                public void onFailure(Exception exception) {
                    @{Upload:Of(_this).Reject(string):Call(exception.toString())};
                }
            }).addOnSuccessListener(new OnSuccessListener<UploadTask.TaskSnapshot>() {
                @Override
                public void onSuccess(UploadTask.TaskSnapshot taskSnapshot) {
                    @{Upload:Of(_this).Resolve(string):Call(taskSnapshot.getDownloadUrl().toString())};
                }
            });
        @}
        void Reject(string reason) { Reject(new Exception(reason)); }
    }
}
