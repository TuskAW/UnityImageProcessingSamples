using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaskController : MonoBehaviour
{	
	void Update()
	{
		transform.Translate(0.01f*Input.GetAxis("Horizontal"), 0.01f*Input.GetAxis("Vertical"), 0.0f);
	}
}
