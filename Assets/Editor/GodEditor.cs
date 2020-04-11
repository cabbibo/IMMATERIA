using UnityEngine;
using UnityEditor;
using IMMATERIA;

[CustomEditor(typeof(God))]
public class GodEditor : Editor 
{  
   public override void OnInspectorGUI()
    {
       

        God god = (God)target;
        if(GUILayout.Button("Rebuild"))
        {
            god.Rebuild();
        }


        if(GUILayout.Button("Save Current Forms"))
        {
            god.SaveAllForms();
        }


        if(GUILayout.Button("Full Rebuild"))
        {
            god.FullRebuild();
        }


         DrawDefaultInspector();


    }


   


}