using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class HealthManager : MonoBehaviour
{
    // Start is called before the first frame update

    public static int health = 0;

    public Image[] hearts;
    public Sprite fullheart;
    public Sprite emptyheart;

    private void Start() {
        health = 0;
    }

    // Update is called once per frame
    void Update()
    {
        foreach (Image img in hearts)
        {
            img.sprite = emptyheart;
        }
        for (int i = 0; i < health; i++)
        {
            hearts[i].sprite = fullheart;
        }
        
    }
}
