using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA {
public class Scene : Cycle
{

   public bool getTotals;
   public int totalVertCount;
   public int totalTriCount;
   
   public void OnEnable(){

        Reset();
        _Destroy(); 
        _Create(); 
        _OnGestate();
        _OnGestated();
        _OnBirth(); 
        _OnBirthed();
        _Activate();
   }


   public void OnDisable(){
      _Destroy(); 

        _Deactivate();  
   }



   public override void OnBirthed(){
    if( getTotals ){
      totalTriCount = 0;
      totalVertCount = 0;
      AddToCount(this);
    }
   }

   public void AddToCount(Cycle cycle){

    foreach( Cycle c in cycle.Cycles){
      
      if( c is Form && !( c is IndexForm)){
        totalVertCount += ((Form)c).count;
      }

      if( c is IndexForm ){
        totalTriCount += ((IndexForm)c).count;
      }

      AddToCount(c);
    }

   }
   
}
}
