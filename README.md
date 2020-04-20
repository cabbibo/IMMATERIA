
# IM || MATERIA
Hi there and welcome to the **IM || MATERIA** readme!


   
I want to take you through the basics of the system, while making it so you can get to playing as quickly as possible! If anything doesn’t make sense, please let me know @cabbibo , as a bug, or just send it to my personal email isaac...landon...cohen ( gmail dot com )

Additionally, I’ve started a discord to help you get up and running and ask any strange questions: [https://discord.gg/DRhbR4C](https://discord.gg/DRhbR4C)

And plan on doing weekly streams ( though I’m not quite sure when! ) If you would like to be a guest on one of these streams and build something together, let me know, I would love to have you!


  
  

# Examples / Tutorials:
if you are just a 'show me a code' person, download the repo, go into scenes, and start playing. Below are video tutorials of me setting up each one of the example scenes 


### Beginner
- [Scenes/Beginner/MyFirstReality](https://youtu.be/ByIYB63Cre8)
- [Scenes/Beginner/MyFirstSimulation](https://youtu.be/LUkdVDGZGzY)
- [Scenes/Beginner/MyFirstBody](https://youtu.be/-d8re8Cn9FY)
- [Scenes/Beginner/MyFirstTransferLifeForm](https://youtu.be/pouFnB6GAm4)
- [Scenes/Beginner/MyFirstGooeyMesh](https://youtu.be/H_08R0Mzq54)
- [Scenes/Beginner/MyFirstBinding](https://youtu.be/D5t4-ZiYMH0)

### Intermediate

- [Scenes/Intermediate/FormsOnForms](https://youtu.be/GC5f3d3uanM)
- [Scenes/Intermediate/FormsOnFormsOnForms](https://youtu.be/Vsf-uR1EpQc)
- [Scenes/Intermediate/CreatingCustomLifeform](https://youtu.be/qudxL2_Ynr8)



## TOPICS: 
I am hoping to record videos of each the following scenes, but for now, you can find them as put together scenes in the repository

**_Hair_** 
- Scenes/Hair/HairOnStaticMesh
- Scenes/Hair/HairOnDynamicMesh
- Scenes/Hair/HairOnScene 
- Scenes/Hair/RopeOnTransformBuffers 

**_Particles_** 
- Scenes/Particles/EmitFromMesh
- Scenes/Particles/DisformedByTransformBuffer 
- Scenes/Particles/ParticlesWithTrails 

**_Meshes_**
- Scenes/Particles/MeshesAsParticles
- Scenes/Meshes/MeshesAsGrass
- Scenes/Meshes/MeshesAsTrail 
- Scenes/Meshes/MeshesAsRope 

**_Skinned Meshes_**
- Scenes/Meshes/SkinnedMeshRenderer ( Coming Soon )
- Scenes/Meshes/HairOnSkinnedMeshRenderer ( Coming Soon )

**_SDF_**
- Scenes/SDF/SDFBasic
- Scenes/SDF/MeshToSDF 
- Scenes/SDF/SDFToMesh
- Scenes/SDF/ParticlesOnSDF 



**_Cloth_**
- Scenes/Cloth/ClothOnSDF ( Coming Soon )
- Scenes/Cloth/ClothOnTransformBuffer ( Coming Soon )
- Scenes/Cloth/ClothPinned ( Coming Soon )
- Scenes/Cloth/HairyCloth ( Coming Soon )

**_GOO_** 
- Scenes/Goo/SmoothGooMesh ( Coming Soon )
- Scenes/Goo/HumanDisformedGoo ( Coming Soon )

**_Materials_**
Scenes/MaterialExplorer includes the following materials
- Basic Color 
- Basic Color with Shadow
- Normal 
- Flat Normals
- Basic Unity Surface Shader
- Basic Grab Lighting
- Toon
- Toon with Outline
- Toon Normal mapped
- Reflective Material
- Iridescent Material
- Crazy Material
- Triplanar Mapping ( Coming Soon )
- Force Materials ( Coming Soon )
- Sketch Materials ( Coming Soon )
- Volumetric Depth Materials ( Coming Soon )
  




# Cheat Sheet
Here is some hopefully simple and useful information

_**God**_
```
- Every Scene must have a God Object
- Toggling godPause pauses edit mode execution
- Toggling allInEditMode will force the update loop to run
- CTRL + b rebuilds the scene.
  ( if you hate that change it in GodEditor.cs )
```

_**Data**_
```
- Every God must have a data
```
_**Cycle**_
```
// To programatically make a cycle run,
SafeInsert( cycle )

// To Remove
Cycles.Remove( cycle )

// Cycles will automatically remove any null refs
// in their list of child cyles
```

##
_**Form**_
```
// To set the structSize of your form to 16
public override void SetStructSize(){ structSize = 16; }

// To set the count of your form to 100
public override void SetCount(){ count = 100; } 

// To populate your form buffer with random numbers
public override void Embody(){
  float[] vals = new float[ count * structSize ];
  for( int i  = 0; i < count * structSize; i++ ){
    vals[i] = Random.Range(0.0f, 1.0f);
  }
  SetData(vals);
}

// To assign data at run time (see TransformBuffer.cs)

```
##
_**Life**_
```
// To Bind The main form 
// Which defines how many times we are going to run
BindPrimaryForm("_NameInShader",form);

// To Bind any other form
BindForm("_NameInShader",form );

// To Bind a transforms position
BindVector3("_NameInShader", () => myTransform.position);

//To Bind from somewhere not within the actual life file
Life life; Texture texture;
life.BindTexture("_NameInShader", () => texture);
```

##
_**Body**_
```
// Set Uniform of body material
mpb.SetInt("_NameInShader",myInt);
```
# The Components
 Here I'm going to try and explain what and why the different parts of the system do. I've been trying to make it so that if you aren't a 'code-y' type person you can just play  with the objects in the editor, but still, it helps to know what they heck they all are
 
## Cycle
*Everything is a cycle,
We breath in… and out … just to begin again.
The tide comes in and retreats, we grow old and die.*

***As with our universe, so it is with IM || MATERIA.*** 
#

### About
Cycle.cs is the base component of this whole system. Every single object inherits from it if its part of the **IM || MATERIA** system.

You can think of it as our own custom ```MonoBehaviour``` with a bit more customization. 

The reasons for this cycle of 4 fold:

1) To be able to more accurately define the order of execution of different files
2) To have a bit finer grained startup process
3) To be able to run in Edit mode / rebuild whenever we want
4) Make debugging a vital part of the system

Essentially, we are going to build out our own custom ordered call graph by ordering our cycles.

```
Top Level Cycle Calls:
  Cycle A which calls:
    Cycle A.a 
    Cycle A.b
    Cycle A.c
  Cycle B which calls:
    Cycle B.a
    Cycle B.b
  Cycle C 
```
Now the order of execution is going to go straight down this list calling 

```
Top Level Cycle
Cycle A
Cycle A.a
Cycle A.b
Cycle A.c
Cycle B
Cycle B.a
Cycle B.b
Cycle C
```
This is all fine and dandy, but what if ```Cycle A``` requires something to be done on ```Cycle A``` before it runs? For example, what if ```Cycle A``` is a list of particles that need to be placed smoothly along a mesh ( ```Cycle B``` ) surface? We need the mesh to be created before ```Cycle A``` before it gets run otherwise its going to place it on ***WHAT?*** nothing? 

Now in Unity, we would go into the script execution order and make sure ```Cycle B``` got called before ```Cycle A``` but that gets *really* tedious, especially with more complex systems.

In **IM || MATERIA** though, we can just reorder the cycle structure in our inspector, making sure that everything goes in the order we want. In code it our example above it would look like:


```
Top Level Cycle Calls:
  Cycle A which calls:
    Cycle A.a 
    Cycle A.b
    Cycle A.c
  Cycle B which calls:
    Cycle B.a
    Cycle B.b
  Cycle C 
```
But in editor, we just go from this:


to this:



### The Innards

Inside Cycle, there is a whole bunch of fun stuff happening, but the primary goal is to set up our entire call graph. The 'Cycle' looks like this:

```
Create
OnGestate
WhileGestating
OnGestated
OnBirth
OnBirthing
OnBirthed
OnLive
WhileLiving
OnLived
OnDie
WhileDying
OnDied
Destroy
```

Which gives us a **lot** more to work with  than trying to figure out if we should call something on awake, start etc.

Cycles additionally have 

```
Activate
Deactivate
``` 

if we want to turn them on and off during any other part of their time alive in our program.

### Logistics
Since everything single object in our library is inheriting from Cycle there is going to be a lot of overriding going on! 

For this reason, I've made it so that every ```Step``` of the way has a 

``` _Step (Don't Screw With this)```

and a 

``` Step (Play Away!)```

This means that:

```
public override void WhileLiving( float v ){
  // Do my custom fun stuff here
}
```

is kosher, but if you do
```
public override void _WhileLiving( float v ){
  // DANGER // DANGER // DANGER //
}
```

You are going to have a bad time!

*( ok you can play with it some, as you will see me do with some of the forms etc. but just be careful please )*

Now that was a TON of text I know, but this is the cycle that is *everything*, so considering its not that bad? ...maybe?


SNAZZY PIC

## Form

*We are all made from stardust. Just a strange arrangement of leptons, quarks, protons, neutrons, elements, cells.*

*The thing that is our physical form, at any single moment, is no more than these tiny elements.*

***As with our universe, so it is with IM || MATERIA.***

##

### About

At its core, a Form is just a cycle that helps us with compute buffers. 

Here are some of the functions of Form:

1) Making sure our compute buffer gets set up correctly
2) Adding and getting data from our compute buffer
3) Saving compute buffers out for later use


A compute buffer in unity is created by calling:
```
new  ComputeBuffer( count , stride );
```

Where ```count``` is the number of objects in our ComputeBuffer
and ```stride``` is the amount of information for each one of those objects.

This makes a big ol' chunk of memory in the GPU that we can then put data into. 

The GPU is *very* efficient, and like many efficient things, is also *very* simple. This means that we can't just give it a bunch of weird unity stuff and expect it to know what we are doing. The only way to get data in there is to pass an array of ```float[]``` or ```int[]``` to the function

```
buffer.setData( values )
```




Lets look at an example representing a list of particles that have a positions, our ‘array’ of particles on the CPU might look a little like:

```
int numParticles;
Vector3[] particles = new Vector3[numParticles];
```
and then we could go and update our particles position
``` 
for( int i = 0; i < numParticles; i++ ){
  particles[i] = Random.insideUnitSphere;
}
```

And that would be that. 

**HOWEVER**

if we want to be playing with REAL power in the GPU, we need to take all that information, flatten it out and send it to our buffer.

```
buffer = new ComputeBuffer( numParticles , 
              sizeof(float) * 3 );

float [] values = new float[ numParticles * 3 ];

int index = 0;
for( int i = 0; i < numParticles; i++; ){
  values[index++] = particles[i].x;
  values[index++] = particles[i].y;
  values[index++] = particles[i].z;
}
buffer.setData(values);
```

  ### The Innards

Forms cycle looks a bit like:

```
Create:
  - Set up the size of our buffer
  - Set up what things are in our buffer
  - Set up what kinda of buffer it is

OnGestate:
  - Make the actual buffer
  - Populate the buffer with information

Destroy:
  -Release buffer
```
The spiciest part of this whole thing is the entire *populate the buffer with information* . This is done in a step called ```Embody``` that is Form specific. For example, if we wanted to place points randomly, we would do all of this in the ```Embody``` function. 

This ```Embody``` function can start to get pretty CPU intensive. If we have a million particles and we want to place them all in relationship to each other, thats ALOT of calculations to be doing every runtime. But **NEVER FEAR** because Form also has automagic saving built into this.

When a Form is first created, it will run its ```Embody``` function and then save out the result to a folder called ```DNA``` in ```StreamingAssets```

Every time you remake the form, it will go an look for its saved ```DNA``` loading it straight into memory instead of having to go through the process of remaking everysingle particles position!




  ### Logistics
   ```diff
! You can toggle 'Always Remake' on form
``` 
If you are planning on changing what embody does frequently, or the embody function should run differently every time. Doing so will make it less efficient, but thats OK!



  ```diff
! MAKE SURE YOU ADD *.DNA / *.dna to your .gitignore!
```
This is because under the hood, ( specifically in Saveable.js ) these files are sort of 'temporary' and can get remade with different names as frequently as forms change. This means that you will be pushing a bunch of data files that change with every commit. If you want to you can ( aka if you've got a form saved that you really like and want other folks to have ) but in general, if someone pulls the project with no *.dna* in it, it will make all of those files the first time it runs!




## LIFE

*Each moment is a transformation.
A static form, unchanging, unmoving, this is death.
That same form, dancing, playing, singing?*

*That is life.* 

***As with our universe, so it is with IM || MATERIA***

  ##
  ### About
  Life is a helper cycle to run compute shaders. 
  Some  reasons for its existence:
  
  - There is a bit of overhead work to setting up compute shaders
  - Making sure that you've got the right information can get confusing
  - Without life, form is boring.

A Compute shader is a single set of instructions that are run as many times as you want, all in parallel! Thats really cool because if have millions of particles, we dont want to simulate 1 particle, then simulation the next particle, etc. we want to simulate all the particles at once!

The problem again is that because the GPU is simple and efficient, we need to make sure that all the thing it needs to run these instructions are present and accounted for!

A ```Life``` will have a Primary ```Form``` that is bound to it.

It will use that to get information for how many times it should run etc.

In addition, ```Life``` contains a bunch of helpers that make sure that right data is getting passed into our shader. 

To illustrate this example, lets think about a compute shader where we want to have a reference of our hand in the shader.

If we were writing a shader system from scratch, every frame we would just called:

```
shader.SetVector("_NameInShader", handTransform.position);
```
But this would mean we would need to write a new script for every new shader that has different inputs. Thats alot of typing!

Instead ```Life``` uses a system where we set up a function that we bind which will call itself right before the shader runs. Whats exciting about it is we can do it from anywhere else in our code instead of just our shader scripts update loop. The above example could then rest in a different script called ```BindHandPosition.cs``` calling

```
Life life;
Transform hand;

// in our bind step
public override void Bind(){
  life.BindVector3("_NameInShader", () => hand.position );
}
```
This might look like more code, but now we can just drag that game object wherever we want and hook it up to whatever we want, instead of writing a new script for every single life.

(check out ```Binder.cs``` and all the tons of things that inherit from it to see just how many nice components there are! )

### The Innards

Internally, Lifes Cycle looks like:

```
Create
  - Set up our list of bound items
  - Find the correct kernel using the kernel name
  - Get the amount of times we will run!

WhileLiving
  - make sure the number is right
  - Set all of our shader attributes
  - Get and Set all of our bound in formation
  - Run our shader
  - Do anything we want to after the shader is run

```

Unlike ```Form``` where most things are happening at start time, Life is happening at runtime. You can see that it goes and grabs the kernel we want to run from compute shader, and then figures our how many times it should run from our PrimaryForm, and then goes along and does the stuff!

While it *is* possible to get data back out from the GPU, its *verrrry* expensive, so **IM||MATERIA** tries to keep it as GPU side as possible. That being said, there ways to get data back out  ( which you can see in ```CalcLife.cs``` or ```ReduceLife.cs```

### Logistics

If you want to make sure there is going to be data bound in your shader, override the ```Bind``` function and add in everything you want there, AKA:

```
Transform A; Transform B; Transform C;
public override void Bind(){
  BindVector3("_NameA", () => A.position);
  BindMatrix("_NameB", () => B.localToWorldMatrix);
  BindFloat("_NameC", () => C.position.y);
}
```

If you want something to run multiple times per input Form object, you can change the ```countMultiplier``` property but be careful!

Also remember each life coresponds to a single kernel in a compute shader, so you've GOT to give it the right name!

if you want a life to only run once, you can either toggle ```selfStop``` to true, or call ```YOLO()```

remember that ```Life``` only runs when active!


## Body

 *What are we without our corporeal form
 no matter how much we dance, 
 it is the body we see*
 ***As with our universe, so it is with IM || MATERIA***
  ##

### About
```Body``` is a cycle exists just so we can get things onto the screen. 

This is where we get back into the typical graphics pipeline and make stuff actually render to the screen!

Normally unity does this for you with its ```MeshRenderer``` but luckily also provides another function ```DrawProcedural``` so that we can draw whatever we want to the screen instead of just their meshes!

All it really has are 3 things:

- A reference to a buffer of our verts ( positions, normals etc.)
- A reference to a buffer of our indices ( for triangle creation )
- A material property block ( so we are spawning new materials in edit mode )

Its job is to take care of inputing all this information  and the calling ```DrawProcedural``` with the right properties assigned.

### The Innards
Body's Cycle looks like

```
Create
  - make our property block
  - get our verts and tris if they dont exist
  - add our verts and our triangles to our cycles

WhileLiving
  - Assign our buffers and info
  - DRAW IT 
```

pretty simple, more our less a normal mesh renderer, but that happily runs during edit mode...


### Logistics

Mostly I have some TODOs for this one. I want to be able to easily Bake out OBJs, as well as have a 'binding' system that is similar to the ```Life``` binding system. Might take a lil though :p


## God

*Look, I don’t know how to explain this one.
I guess we just need something that says ‘Let There Be Light?’*

***As with our universe, so it is with IM || MATERIA***
##

### About

God exists to:

- Make all our code run in unity
- Restart our Cycles
- Save Forms to disk
- Delete Forms from disk

Its pretty straight forward basically making sure that when unities 'onenable' code gets run, all our cycles get spun up, when 'ondisable' happens they all get destroy, and when 'update' is call it does the things in the cycles that need to get done.

### The Innards

Instead of looking at what happens during God's cycle, lets see what happens when different unity events are call

```
  Start - Nothing
  Awake - Nothing
  OnEnable - Rebuild
  OnDisable - Destroy
  LateUpdate - UpdateFunctions

where:
 
 Rebuild: 
   - Reset Cycle State
   - pre-destroy ( to really clean it up )
   - Create
   - OnGestate
   - OnGestated
   - OnBirth
   - OnBirthed

Destroy
  -OnLived
  -OnDie
  -OnDied
  -Destroy

Update
  - ( first frame OnLive )
  - if gestating WhileGestating
  - if birthing WhileBirthing
  - if living WhileLiving
  - if dying WhileDying
```
This means every part of our cycle is now getting run!

That being said **God is Incomplete**

I talked about having finer granularity on start up and spin down, but this really doesn't have as much as I want. 

For example, if I load in a file of 2 million particles, its all going to try and happen at once, which will make you drop frames ( and dropping frames is bad ). However if I make a more 'progressiveloader' the makes it so you could only load in 1000 particles each frame while its gestating, well that would truly be something special

### Logistics
Every scene should have a ```God``` if you want your code to run. You could make your own ```God``` i guess if you want? its def not a jealous ```God```. 
Especially considering that they are incomplete...

```diff
! If everything is going bananas,
! Turn godPause on, and press rebuild
! to see whats going wrong at runtime!
```

```diff
! CTRL + b is mapped to 'rebuild'
```
Also, remember that Forms save to disk! This means that if you have let your Simulations get to a point that you like , and want them to Start from that point, you can press 'save all forms' and save all your forms to disk!

If things get screwed up, ( maybe you did a simulation that now is writing a NaN to disk ) you can always press 'Full Rebuild' which will throw away everything in the ```DNA``` folder and rebuild everything from scratch!




  
  
  

## Data


Data exists as a simple holding script for allll the info we want accesible to every single cycle. A reference to data will be passed down to every single cycle, so we can call it in any cycle at any time. It might container helper functions, references to object or pretty much anything else you want all your cycles to know about.

Data.cs should be custom written for every project. The one in this project contains the most basic possible data I can thing of :)
  
  
  
  
  
  
  
  

# FAQ / Gotchas

  

-   Add *.DNA / * .dna to your .gitignore ( unless you want big files and aren’t rebuilding often )
    
-   Since we are dealing with draw procedural of unknown sizes, our draw calls tend to have infinite bounds, which means no occlusion culling! I haven’t thought about an elegant way to solve this, but if you want to play with it yourself
   
-   Cycles need to be ACTIVE to run (including running their children)
    
-   Calling ```DebugThis``` in any cycle will make it so you can click on the game object that is firing the debug call.

- Debug draws to the debug layer! so you are gonna need that layer