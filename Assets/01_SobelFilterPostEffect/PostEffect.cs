using UnityEngine;

[RequireComponent(typeof(Camera))]
public class PostEffect : MonoBehaviour
{
	[SerializeField]
	private Shader _shader;

	private Material _material;

	void Start()
	{
        _material = new Material(_shader);
	}

	private void OnRenderImage(RenderTexture source, RenderTexture dest)
	{
		Graphics.Blit(source, dest, _material);
	}
}
