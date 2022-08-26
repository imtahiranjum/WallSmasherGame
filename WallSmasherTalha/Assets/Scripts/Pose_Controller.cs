using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
public enum Pose_States
{
    idle,sitting1,sitting2,sitting3,sitting4,sitting5,blocking,plank,kneeling,laying1,laying2,laying3,laying4,poses,poses_off
}


public class Pose_Controller : MonoBehaviour
{
    static Pose_Controller inst; 
    [SerializeField]
    private Animator anim;
    Quaternion rot;

    public Transform init_point;
    // Start is called before the first frame update
    void Start()
    {
        //StartCoroutine(anim_test());
        inst = this;
        
       rot= Quaternion.Euler(transform.rotation.x, transform.rotation.y, transform.rotation.z);
       
    }
    public static Pose_Controller getInst()
    {
        return inst;
    }


    IEnumerator anim_test()
    {
        yield return new WaitForSeconds(1f);
        states(Pose_States.poses);
    }

    // Update is called once per frame
    void Update()
    {
        transform.position = init_point.transform.position;
    }

   public void states(Pose_States pose)
    {
        switch (pose)
        {
            case Pose_States.idle:
               
                anim.SetInteger("Pose", 0);
                transform.DORotate(new Vector3(0f, 0f, 0f), 1f);
                break;
            case Pose_States.poses:
               // transform.rotation = rot;

                anim.SetBool("PoseMaker",true); break;
            case Pose_States.sitting3:
               // transform.rotation = rot;

                anim.SetInteger("Pose",1);
                transform.DORotate(new Vector3(0f, 90f, 0f), 0.5f);

                break;
            case Pose_States.sitting1:
                anim.SetInteger("Pose", 2);
                transform.DORotate(new Vector3(0f, 90f, 0f), 0.5f);

                break;
            case Pose_States.laying2:
               

                anim.SetInteger("Pose", 3);
                transform.DORotate(new Vector3(0f, 90f, 0f), 0.5f);
                break;
            case Pose_States.laying1:
               

                anim.SetInteger("Pose", 4);
                transform.DORotate(new Vector3(0f, 0f, 0f), 0.5f);
                break;
            case Pose_States.kneeling:
               
                anim.SetInteger("Pose", 5);
                transform.DORotate(new Vector3(0f, 0f, 0f), 0.5f);
                break;
            case Pose_States.laying3:
                anim.SetInteger("Pose", 6);
                transform.DORotate(new Vector3(0f, 90f, 0f), 0.5f);
                break;
            case Pose_States.laying4:
                transform.rotation = rot;

                anim.SetInteger("Pose", 7);
                transform.DORotate(new Vector3(0f, 0f, 0f), 0.5f);
                break;
            case Pose_States.blocking:
                anim.SetInteger("Pose", 8);
                transform.DORotate(new Vector3(0f, 90f, 0f), 0.5f);
                break;
            case Pose_States.plank:

              
                anim.SetInteger("Pose", 9);
                transform.DORotate(new Vector3(0f, 90f, 0f), 0.45f);
                break;
               
            case Pose_States.sitting5:
                anim.SetInteger("Pose", 10);
                transform.DORotate(new Vector3(0f, 90f, 0f), 0.5f);
                break;

            case Pose_States.sitting2:
                anim.SetInteger("Pose", 11);
                transform.DORotate(new Vector3(0f, 0f, 0f), 0.5f);

                // transform.DORotate(new Vector3(0f, 90f, 0f), 1f);
                break;
            case Pose_States.sitting4:
                anim.SetInteger("Pose", 12);
                transform.DORotate(new Vector3(0f, 0f, 0f), 0.5f);

                //transform.DORotate(new Vector3(0f, 90f, 0f), 1f);
                break;
            case Pose_States.poses_off:
                anim.SetBool("PoseMaker", false); break;

        }

    }
}
