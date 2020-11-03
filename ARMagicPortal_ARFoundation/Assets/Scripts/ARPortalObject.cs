using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ARPortalObject : MonoBehaviour
{
    Renderer rend;
    Material[] materials;

    private void Awake()
    {
        rend = GetComponent<Renderer>();
        materials = rend.materials;
    }

    public void UpdatePortalInfo(Vector3 portalPosition, Vector3 portalForward)
    {
        foreach (Material mat in materials)
        {
            mat.SetVector("_PortalPos", portalPosition);
            mat.SetVector("_PortalDir", -portalForward);
        }
    }
}
