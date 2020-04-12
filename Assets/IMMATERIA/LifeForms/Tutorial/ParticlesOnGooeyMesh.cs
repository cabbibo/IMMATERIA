using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace  IMMATERIA{
    

public class ParticlesOnGooeyMesh : Cycle
{

    public Mesh mesh;

    public Material bodyMaterial;
    public Material particleMaterial;

    public int numAnchorParticles;

    public ComputeShader gooeyTransferShader;
    public string gooeyTransferKernel;

    
    public ComputeShader anchorTransferShader;
    public string anchorTransferKernel;


        public ComputeShader particleBodyTransferShader;
    public string particleBodyTransferKernel;


    public Transform disformer;
    public string disformerNameInShader;



    /*
    Visual and physical parameters to play with
    */

     [Range(0.01f, .2f)]
    public float particleRadius;

    [Range(0.7f, .99f)]
    public float dampening;

    [Range(0f,1f)]
    public float force;

    [Range(0f,1f)]
    public float disformForce;


    [Range(0f,1f)]
    public float particlesFollowForce;

     [Range(0.7f, .99f)]
    public float particlesFollowDampening;

    [Range(0.0f, .4f)]
    public float particlesOutAmount;



    /*

        Everything beneath here should auto populate

    */
    
    public MeshVerts baseVerts;


    public Body body;
     public MeshTris triangles;
    public MeshVerts gooeyVerts;
    public Life gooeyTransfer;

    
    // Getting particles onto the mesh
    public Life anchorTransfer;
    public ParticlesOnDynamicMesh particles;
    public Life particleBodyTransfer;
    public Body particleBody;    
    public ParticleTransferVerts particleTransferVerts;
    public ParticleTransferTris particleTransferTris;






    public BindTransform bindTransform;
    public BindPosition bindPosition;


    public override void Create(){



        // first make our base verts that we will copy
        if( baseVerts  == null ){ baseVerts = gameObject.AddComponent<MeshVerts>(); }
        baseVerts.mesh = mesh;

        SafeInsert( baseVerts );

        /*

            Our gooey stuff

        */
        
        // set up the things we will need to make our gooey verts
        if( body == null ){ body = gameObject.AddComponent<Body>(); }
        if( gooeyTransfer == null ){ gooeyTransfer = gameObject.AddComponent<Life>(); }
        if( gooeyVerts == null ){ gooeyVerts = gameObject.AddComponent<MeshVerts>(); }
        if( triangles == null ){ triangles = gameObject.AddComponent<MeshTris>(); }


        gooeyTransfer.shader = gooeyTransferShader;
        gooeyTransfer.kernelName = gooeyTransferKernel;

        // setting up the meshes
        gooeyVerts.mesh = mesh;
        triangles.toIndex = gooeyVerts;

        // setting up the body
        body.verts = gooeyVerts;
        body.triangles =  triangles;
        body.material = bodyMaterial;

        //using a transform binder to get our info into gooey transform
        if( bindTransform == null ){ bindTransform = gameObject.AddComponent<BindTransform>(); }
        bindTransform.toBind = gooeyTransfer;


        //using a position binder to get our disformer into gooey transform
        if( bindPosition == null ){ bindPosition = gameObject.AddComponent<BindPosition>(); }
        bindPosition.toBind = gooeyTransfer;
        bindPosition.boundTransform = disformer;
        bindPosition.boundName = disformerNameInShader;


        // Body is going to add our verts and tris for us!
        SafeInsert( body );
        SafeInsert( gooeyTransfer );
        SafeInsert( bindTransform );
        SafeInsert( bindPosition );


        /*

            Particles On Our Gooey Stuff!

        */

        // set up the stuff to place particles on those gooey verts
        if( particles == null ){ particles = gameObject.AddComponent<ParticlesOnDynamicMesh>(); }
        if( anchorTransfer == null ){ anchorTransfer = gameObject.AddComponent<Life>(); }

        particles.count = numAnchorParticles;
        particles.mesh = mesh;


        anchorTransfer.shader = anchorTransferShader;
        anchorTransfer.kernelName = anchorTransferKernel;

        SafeInsert( particles );
        SafeInsert( anchorTransfer );


        /*
            Turning our particles into pretty renders
        */

        if( particleBody            == null ){ particleBody             = gameObject.AddComponent<Body>();                  }
        if( particleTransferVerts   == null ){ particleTransferVerts    = gameObject.AddComponent<ParticleTransferVerts>(); }
        if( particleTransferTris    == null ){ particleTransferTris     = gameObject.AddComponent<ParticleTransferTris>();  }
        if( particleBodyTransfer    == null ){ particleBodyTransfer     = gameObject.AddComponent<Life>();                  }

        particleBodyTransfer.shader = particleBodyTransferShader;
        particleBodyTransfer.kernelName = particleBodyTransferKernel;

        particleTransferVerts.particles = particles;
        particleTransferTris.toIndex = particleTransferVerts;


        // setting up the body
        particleBody.verts = particleTransferVerts;
        particleBody.triangles =  particleTransferTris;
        particleBody.material = particleMaterial;

        // Body is going to add verts and tris for us!
        SafeInsert( particleBody );
        SafeInsert( particleBodyTransfer );

    }

    public override void Bind(){



        // Binding all the neccesary values for our gooey body
        // Remember that we can also use 'binders' in conjunction
        // to do the binding for us
        gooeyTransfer.BindPrimaryForm("_VertBuffer",gooeyVerts);
        gooeyTransfer.BindForm("_SkeletonBuffer", baseVerts );

        gooeyTransfer.BindFloat("_Dampening", ()=> dampening);
        gooeyTransfer.BindFloat("_DisformerForce", ()=> disformForce);
        gooeyTransfer.BindFloat("_Force", ()=> force);



        // Binding all the neccesary values for out particle simulation
        anchorTransfer.BindPrimaryForm("_ParticleBuffer", particles );
        anchorTransfer.BindForm("_VertBuffer", gooeyVerts );

        anchorTransfer.BindFloat("_OutAmount", () => particlesOutAmount );
        anchorTransfer.BindFloat("_Force", ()=> particlesFollowForce );
        anchorTransfer.BindFloat("_Dampening", ()=> particlesFollowDampening );


        //Binding all values for the particle transfer ( in order to make quads! )
        particleBodyTransfer.BindPrimaryForm("_VertBuffer",particleTransferVerts);
        particleBodyTransfer.BindForm("_SkeletonBuffer",particles);

        particleBodyTransfer.BindFloat("_Radius", ()=> particleRadius );
        data.BindCameraData( particleBodyTransfer );



    }

    public override void OnLive(){
        _Activate();
    }


}
}