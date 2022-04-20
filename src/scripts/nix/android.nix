# run `nix-build <this file>`

# https://nixos.wiki/wiki/Android
#  Building Android applications with the Nix package manager: https://sandervanderburg.blogspot.com/2014/02/reproducing-android-app-deployments-or.html

with import /home/xieby1/Codes/nixpkgs {
# with import /home/xieby1/temp-nixpkgs {
  config.android_sdk.accept_license = true;
};

androidenv.emulateApp {
  name = "diary";
  app = ./org.billthefarmer.diary_187.apk;
  enableGPU = false;
  # get these info by `nixpkgs/pkgs/development/mobile/androidenv/repo.json`
  # see if installed `sdkmanager --list`
  platformVersion = "18";
  abiVersion = "x86";
  systemImageType = "google_apis";

  package = "org.billthefarmer.diary";
  activity = "org.billthefarmer.diary.Diary";

  avdHomeDir = "$HOME/.diary";
  sdkExtraArgs = {
    emulatorVersion = "30.8.4";
    includeSystemImages = true;
  };
}
