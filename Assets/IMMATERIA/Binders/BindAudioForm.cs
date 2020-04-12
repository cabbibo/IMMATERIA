using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindAudioForm : Binder
{ 
    public AudioListenerTexture audioForm;
    

    public override void Bind(){
      if(  audioForm == null ){  audioForm = GameObject.Find("God").GetComponent<AudioListenerTexture>(); }
      toBind.BindForm("_AudioBuffer" , audioForm );
    }


  }
}