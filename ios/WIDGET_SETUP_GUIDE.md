# Adding iOS Widget Target in Xcode

Since I cannot modify the `.xcodeproj` file directly, please follow these steps to add the widget target:

1. Open `Runner.xcworkspace` in Xcode.
2. Go to `File` -> `New` -> `Target...`.
3. Search for **Widget Extension** and select it.
4. Product Name: **MangoWidget**.
5. Ensure **Include Configuration Intent** is **unchecked**.
6. Click **Finish**. 
7. If asked to "Activate 'MangoWidget' scheme?", click **Activate**.
8. In the project navigator, you will see a new `MangoWidget` folder.
9. **Delete** the auto-generated `MangoWidget.swift` and `MangoWidget.intentdefinition` (if any).
10. Move the files I created in `ios/MangoWidget/` into this folder if Xcode didn't already pick them up.
11. **App Groups**:
    - Go to the **Runner** target -> **Signing & Capabilities**.
    - Click **+ Capability** and add **App Groups**.
    - Click **+** and add `group.com.mango.app.689FAA5F`.
    - Repeat these steps for the **MangoWidget** target.
