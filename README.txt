
USAGE
-----
Add the following to your project.xml:
    
    <android target-sdk-version="14" />
    <template path="../../barcode-0.1/templates/MainActivity.java" rename="src/my/app/package/MainActivity.java" if="android" />

    
On iOS, copy project\iphone\ZBarSDK\Resources\* to your Xcode project root.
    
    
SIMULATOR
---------
You can add photos to the simulator to emulate the camera by doing:
    - Open the Window in mac where your images are stored.
    - Open your simulator another side.
    - Now drag your image from mac window to simulator, simulator will open safari, 
      and in a safari tab your image will be shown.
    - Tap & press down on image in simulator,
    - There will be message to "save image", save image.
    - It will be added to your iPhone simulator.