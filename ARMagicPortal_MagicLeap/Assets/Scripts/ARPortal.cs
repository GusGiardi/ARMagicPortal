using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ARPortal : MonoBehaviour
{
    [SerializeField] Animator portalAnimator;
    public void CreatePortal(Vector3 position, Vector3 forward, Vector3 up)
    {
        transform.position = position;
        transform.rotation = Quaternion.LookRotation(forward, up);

        Shader.SetGlobalVector("_PortalPos", position);
        Shader.SetGlobalVector("_PortalDir", -forward);
        Shader.SetGlobalInt("_ARPlanesInvisible", 1);

        portalAnimator.SetTrigger("Open");
        gameObject.SetActive(true);
    }
}
