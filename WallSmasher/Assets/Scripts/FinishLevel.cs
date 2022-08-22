using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class FinishLevel : MonoBehaviour
{

    public GameObject levelFinish;
    public Button FinishButton;
    public Button RestartButton;
    public Button TryAgainButton;

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Level Finish")
        {
            levelFinish.SetActive(true);
            if(HealthManager.health <= 0){
                FinishButton.gameObject.SetActive(false);
                RestartButton.gameObject.SetActive(false);
            }
            else{
                TryAgainButton.gameObject.SetActive(false);
            }  
        }
    }
}
