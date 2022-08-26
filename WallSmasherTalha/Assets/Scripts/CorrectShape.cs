using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CorrectShape : MonoBehaviour
{
    // Start is called before the first frame update

    public GameObject fireworks1;
    public GameObject fireworks2;

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Wall")
        {
            Explode();

            Flash.getInstance().flash.gameObject.SetActive(true);
            sliderController.is_disabled = false;
            sliderController.getInstance().slider.interactable = true;
            StartCoroutine(disableSlider());
            StartCoroutine(flashDelay());
            if (HealthManager.health < 3)
            {
                HealthManager.health++;
                //sliderController.slider.value = 0;

            }
            sliderController.getInstance().slider.value = 0;

        }
    }

    void Explode()
    {
        Vector3 pos1 = new Vector3(3f, 2f, 0f);
        Vector3 rotation1 = new Vector3(3f, 271.846f, 30.124f);
        Vector3 pos2 = new Vector3(-3f, 2f, 0f);
        Vector3 rotation2 = new Vector3(0, 90f, 0f);
        GameObject firework1 = Instantiate(fireworks1, pos1, Quaternion.identity);
        GameObject firework2 = Instantiate(fireworks2, pos2, Quaternion.identity);
        firework1.transform.rotation = Quaternion.Euler(rotation1);
        firework2.transform.rotation = Quaternion.Euler(rotation2);
        fireworks1.GetComponent<ParticleSystem>().Play();
        fireworks2.GetComponent<ParticleSystem>().Play();
    }

    IEnumerator disableSlider()
    {
        yield return new WaitForSeconds(3f);
        sliderController.is_disabled = true;
        sliderController.getInstance().slider.interactable = false;
        
    }

    IEnumerator flashDelay()
    {
        yield return new WaitForSeconds(0.2f);
        Flash.doCameraFlash = true;
    }

}
