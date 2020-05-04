using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA {
public class ClothSim : Cycle
{
    public Body body;
    public ClothVerts verts;
    public ClothTris tris;
    public ConnectionList connections;

    public Life forces;
    public ConstraintLife constraint;
    public Life normalize;


    public override void Create(){


        if( body == null ){ body = GetComponent<Body>(); }
        if( verts == null ){ verts = GetComponent<ClothVerts>(); }
        if( tris == null ){ tris = GetComponent<ClothTris>(); }
        if( forces == null ){ forces = GetComponent<Life>(); }
        if( constraint == null ){ constraint = GetComponent<ConstraintLife>(); }
        if( connections == null ){ connections = GetComponent<ConnectionList>(); }
        connections.verts = verts;

        SafeInsert( body );
        SafeInsert( connections );
        SafeInsert( forces );
        SafeInsert( constraint );
        SafeInsert( normalize );

    }


    public override void Bind(){

        forces.BindPrimaryForm( "_VertBuffer", verts );
        forces.BindInt("_NumVertsX" , () => verts.numVertsX );
        forces.BindInt("_NumVertsY" , () => verts.numVertsY );
        constraint.BindPrimaryForm("_ConnectionBuffer", connections );
        constraint.BindForm("_VertBuffer", verts );
        constraint.BindInt("_NumVertsX" , () => verts.numVertsX );
        constraint.BindInt("_NumVertsY" , () => verts.numVertsY );
        normalize.BindPrimaryForm( "_VertBuffer", verts );
        
    }


}
}
