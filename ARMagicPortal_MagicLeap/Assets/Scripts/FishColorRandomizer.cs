using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FishColorRandomizer : MonoBehaviour
{
    [SerializeField] Renderer bodyRenderer;
    [SerializeField] Renderer finRenderer;
    [SerializeField] Renderer tailRenderer;

    [System.Serializable]
    public class ColorGroup
    {
        public Color bodyColor1;
        public Color bodyColor2;

        public Color finColor1;
        public Color finColor2;
        public Color finColor3;
    }
    [SerializeField] ColorGroup[] colorGroups;

    void Start()
    {
        SetColors(Random.Range(0, colorGroups.Length));
    }

    void SetColors(int colorID)
    {
        bodyRenderer.material.SetColor("_Color1", colorGroups[colorID].bodyColor1);
        bodyRenderer.material.SetColor("_Color2", colorGroups[colorID].bodyColor2);

        finRenderer.material.SetColor("_Color1", colorGroups[colorID].finColor1);
        finRenderer.material.SetColor("_Color2", colorGroups[colorID].finColor2);
        finRenderer.material.SetColor("_Color3", colorGroups[colorID].finColor3);

        tailRenderer.material.SetColor("_Color1", colorGroups[colorID].finColor1);
        tailRenderer.material.SetColor("_Color2", colorGroups[colorID].finColor2);
        tailRenderer.material.SetColor("_Color3", colorGroups[colorID].finColor3);
    }
}
