using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerCollision : MonoBehaviour
{
    // Start is called before the first frame update
    public GameObject smoke;
    public static bool colided = false;

    private void OnCollisionEnter(Collision other) {
        if(other.gameObject.tag == "Wall" && colided == false){
            colided = true;
            sliderController.getInstance().slider.value = 0;
            sliderController.is_disabled = false;
            sliderController.getInstance().slider.interactable = true;
            StartCoroutine(disableSlider());
            globalVar.whichToDestroy++;
            WallDestroyer.wallCounter--;
            Destroy(other.gameObject);
            Explode();
            StartCoroutine(GetHurt());
            Debug.Log(globalVar.whichToDestroy);
    }
    }

    void Explode () {
        Vector3 pos = new Vector3(0f,1f,0f);
        GameObject firework = Instantiate(smoke, pos, Quaternion.identity);
        smoke.GetComponent<ParticleSystem>().Play();
      }

    IEnumerator GetHurt(){
  
        Physics.IgnoreLayerCollision(6,7);
        Debug.Log("Get hurt");
        yield return new WaitForSeconds(2);
        colided = false;
        Physics.IgnoreLayerCollision(6,7, false); 


    }

    IEnumerator disableSlider()
    {
        yield return new WaitForSeconds(3f);
        sliderController.is_disabled = true;
        sliderController.getInstance().slider.interactable = false;
        
    }
}
