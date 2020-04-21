//C# script example
using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class CaptureTest : MonoBehaviour {
   


    // Capture frames as a screenshot sequence. Images are
    // stored as PNG files in a folder - these can be combined into
    // a movie using image utility software (eg, QuickTime Pro).
    // The folder to contain our screenshots.
    // If the folder exists we will append numbers to create an empty folder.
    string folder = "ScreenshotFolder";
    int frameRate = 60;
    public int superSize;
    public string folderName;
    public bool captureVid;

    private int startFrameCount;
    public bool capturing;
    private bool oCapturing;

    private string final;

    private string oldFolderName;

    public int speed;
    public int currentFrame;
    public int framesSaved;

    void Start () {


        final = folder+ "/" + folderName;

        // Create the folder
        System.IO.Directory.CreateDirectory(final);

        startFrameCount = Time.frameCount;
        framesSaved = 0;

        currentFrame = 0;
    }



    void LateUpdate () {

        currentFrame ++;
        if( oldFolderName != folderName && capturing == true ){
            
            oldFolderName = folderName;

            final = folder+ "/" + folderName;

            // Create the folder
            System.IO.Directory.CreateDirectory(final);
        }

        if( capturing == true && oCapturing == false ){
            Time.captureFramerate = frameRate;
            framesSaved = 0;
            currentFrame = 0;
        }

         if( capturing == false && oCapturing == true ){
            Time.captureFramerate = 0;
        }

        if( capturing == true && currentFrame % speed == 0 ){
            // Append filename to folder name (format is '0005 shot.png"')
            string name = string.Format("{0}/shot{1:D04}.png", final, framesSaved );
            framesSaved ++;
            // Capture the screenshot to the specified file.
            ScreenCapture.CaptureScreenshot(name,superSize);
        }


        oCapturing = capturing;

        if( !captureVid ) capturing = false;
    }


}
