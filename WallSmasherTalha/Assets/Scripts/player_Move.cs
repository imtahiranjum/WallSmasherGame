using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
public class player_Move : MonoBehaviour
{
    [SerializeField] private Transform endpoint;
    
    
    static player_Move inst;
    
    // Start is called before the first frame update
    void Start()
    {
        inst = this;
         
    }

    // Update is called once per frame
    void Update()
    { 
        wallMove();

    }

   public void wallMove()
    {
         
           transform.position = Vector3.Lerp( transform.position, endpoint.transform.position, 0.04f/(transform.position.z-endpoint.transform.position.z));
            
    }
    public static player_Move getInst()
    {
        return inst;
    }

  
 
}
