using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindAudioForm : Binder
{ 
    public AudioListenerTexture audio;
    

    public override void Bind(){
      if( audio == null ){ audio = GameObject.Find("God").GetComponent<AudioListenerTexture>(); }
      toBind.BindForm("_AudioBuffer" , audio );
    }


  }
}