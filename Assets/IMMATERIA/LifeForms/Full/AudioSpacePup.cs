using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class AudioSpacePup : Cycle
{

  public Particles particles;
  public Life life;

  public Life triLocation;
  public Life resolve;

  public MeshVerts verts;
  public MeshTris tris;

  public Body body;
  public Simulation anchors;



  public RandomPositionParticles repelers;

  public Transform target;

  public Vector3 velocity;
  public Vector3 force;

  public BindTransform transformBinder;



  // We just need these to set all the parameters nicely
  public Hair  hairInfo;
  public ParticlesOnDynamicMesh  hairAnchorParticles;
  public TubeVerts tubeVerts;
  public TubeTransfer tubeTransfer;

  [Header("CPU Parameters")]

  //number of hairs on the space pup!
  public int _NumHairs;

  // resolution of the final mesh up!
  // should be greaterd then num verts per hair, 
  // and not a direct multiple
  public int _HairTubeRows;

  // resolution of final mesh around around hair
  public int _HairTubeColumns;

  // resolution of final mesh around around hair
  public int _HairTubeRadius;


  // needs to be non-zero. Turn down to for less expensive!
  public int   _NumVertsPerHair;

  //Size of hair (hopefully scale independentish)
  public float _HairLength;


  //movement towards target
  [Range(0.1f, .99f)]
  public float _SpacePupToTargetForce;

  [Range(0.7f, .99f)]
  public float _SpacePupToTargetDampening;



  [Header("Compute Parameters")]

  // Amount pulls back
   [Range(0.01f, .99f)]
  public float _ReturnStrength;

  // strength of noise applied to movement 
   [Range(0.0001f, .01f)]
  public float _CurlStrength;
  
  // size of noise applied to movement
   [Range(0.1f, 3.99f)]
  public float _CurlSize;


   // size of noise applied to movement
   [Range(0.1f, 3.99f)]
  public float _CurlSpeed;


  // amount that velocity is multiplied by every frame
   [Range(0.7f, .99f)]
  public float _Dampening;


  // tries and keeps the resolved position from going crazy,
  // the lower the less 'connected' the verts will be to surrounding verts
  // but *hopefully* the more stablee the simulation
   [Range(0.1f, .9f)]
  public float _ResolveReduceAmount;




  [Header("Hair Compute Parameters")]

  // The force of the normal outwards
  [Range(0.01f, 2.99f)]
  public float _OutForce;

  public override void Create(){


    hairAnchorParticles.count = _NumHairs;
    hairInfo.numVertsPerHair = _NumVertsPerHair;
    hairInfo.length = _HairLength;

    force = Vector3.zero;
    velocity = Vector3.zero;



    particles.count = verts.mesh.vertices.Length;

    SafeInsert( verts );
    SafeInsert( life );

    SafeInsert(triLocation);
    SafeInsert( resolve );

    SafeInsert( body ); // particles and tris added to body


    SafeInsert( anchors );
    SafeInsert( transformBinder );

  }

  public override void Bind(){

    life.BindPrimaryForm( "_ParticleBuffer" , particles );
    life.BindForm("_VertBuffer" , verts );
    
    life.BindVector3("_Velocity" , () => this.velocity );

    life.BindForm("_RepelBuffer", repelers);

    life.BindFloat("_CurlStrength", () => _CurlStrength );
    life.BindFloat("_CurlSize", () => _CurlSize );
    life.BindFloat("_CurlSpeed", () => _CurlSpeed );
    life.BindFloat("_ReturnStrength", () => _ReturnStrength );
    life.BindFloat("_Dampening", () => _Dampening  );


    triLocation.BindPrimaryForm( "_ParticleBuffer" , particles );
    triLocation.BindForm("_VertBuffer" , verts );

    resolve.BindPrimaryForm( "_ParticleBuffer" , particles );
    resolve.BindFloat( "_ResolveReduceAmount" , () => _ResolveReduceAmount );


  }

  public override void WhileLiving( float v ){

    force = Vector3.zero;
    
    force += _SpacePupToTargetForce * transform.lossyScale.x *(target.position - transform.position);
    

    //velocity = Vector3.zero;
    velocity += force;
    
    velocity  *= _SpacePupToTargetDampening;
    
    //transform.position += velocity;


    hairInfo.length = _HairLength;

  }



}
}