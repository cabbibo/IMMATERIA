using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class CaptureSceneImages : MonoBehaviour
{

    public string[] sceneNames;
    public int currentScene;

    public int sceneFrames;
    public int numFramesPerScene;

    public CaptureTest  capture;

    // Start is called before the first frame update
    void Start()
    {
        DontDestroyOnLoad(this);
        
       capture.capturing =true;
       NewScene();
    }

   void NewScene(){

       if( currentScene > sceneNames.Length){
           capture.capturing = false;
       }
       SceneManager.LoadScene(sceneNames[currentScene]);
       currentScene ++;
   }

   void Update(){
       sceneFrames ++;
       if( sceneFrames == numFramesPerScene ){
           NewScene();
           sceneFrames = 0;
       }
   }
}
