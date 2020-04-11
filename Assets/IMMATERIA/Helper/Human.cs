using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class Human : MonoBehaviour
{

  public Transform LeftHand;
  public Transform RightHand;
  public Transform Head;

  public float LeftTrigger;
  public float RightTrigger;
  public float Voice;
  public float DebugVal;


  public float oLeftTrigger;
  public float oRightTrigger;
  public float oDebugVal;
  public float oVoice;


  public MeshRenderer LeftHandRenderer;
  public MeshRenderer RightHandRenderer;
  public MeshRenderer HeadRenderer;

  public Collider LeftHandCollider;
  public Collider RightHandCollider;

  public Collider HeadCollider;


  public int type;
  public int id;

  public int RightHandActive;
  public int LeftHandActive;




}}