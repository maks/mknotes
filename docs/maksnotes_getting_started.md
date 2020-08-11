## Meta

I've going the document the process of building the maksnotes app, by actually writing it up as a series of notes that maksnotes app will eventually allow me to manage, along with all my existing notes.

I use a "sort of" [Zettelkasten](https://zettelkasten.de/posts/overview/)

I'm going to be doing this on LInux, actually on most of my machines, its a Debian container inside ChromeOS.

Until maksnotes can at least open and edit notes, I'll start of my editing them in VSCode.

## First steps

so I first created a dir: `mkdir ~/notes`

I then went into the dir I installed Flutter sdk into, renamed it to `flutter-stable` then using instructions from [DartCode docs](https://dartcode.org/docs/quickly-switching-between-sdk-versions/) created a new workspace for the master channel:
```
git worktree add ../flutter-master origin/master
```
and then switched to it and created a new link to point to it as I already had the flutter dir on my path:
```
cd ../flutter-master
git checkout master
flutter doctor
```

then ran:
```
>flutter doctor

Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel master, 1.20.0, on Linux, locale en_US.UTF-8)
 
[✓] Android toolchain - develop for Android devices (Android SDK version 29.0.3)
[✗] Linux toolchain - develop for Linux desktop
    ✗ CMake is required for Linux development.
      It is likely available from your distribution (e.g.: apt install cmake), or can be downloaded from
      https://cmake.org/download/
    ✗ ninja is required for Linux development.
      It is likely available from your distribution (e.g.: apt install ninja-build), or can be downloaded from
      https://github.com/ninja-build/ninja/releases
[!] Android Studio (version 3.4)
    ✗ Flutter plugin not installed; this adds Flutter specific functionality.
    ✗ Dart plugin not installed; this adds Dart specific functionality.
[✓] VS Code (version 1.47.3)
[✓] Connected device (2 available)

! Doctor found issues in 2 categories.
```


So following the [Codelab](https://codelabs.developers.google.com/codelabs/flutter-github-graphql-client/#1) so:
```
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
```

Then `flutter create maksnotes` to create scaffold for the linux app.
