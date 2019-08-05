using UnityEngine;
using UnityEngine.Rendering;

public class SobelFilteringComputeShader : MonoBehaviour
{
    public ComputeShader computeShader;
	public Material inputImageMaterial;
	public Material outputImageMaterial;

	private Texture srcTexture;
	private RenderTexture dstTexture;

	void Start()
	{
		srcTexture = inputImageMaterial.mainTexture;
        dstTexture = new RenderTexture(srcTexture.width, srcTexture.height, 0, RenderTextureFormat.ARGB32);
        dstTexture.enableRandomWrite = true;
        dstTexture.Create();
	}

	void Update()
	{
        if(!SystemInfo.supportsComputeShaders)
        {
			Debug.LogError("Compute Shader is not Support!!");
			return;
        }
		if(computeShader == null)
		{
			Debug.LogError("Compute Shader has not been assigned!!");
			return;
		}

		int kernelID = computeShader.FindKernel("SobelFilterCS");
		computeShader.SetInt("_Width", srcTexture.width);
		computeShader.SetInt("_Height", srcTexture.height);
		computeShader.SetTexture(kernelID, "srcTexture", srcTexture);
        computeShader.SetTexture(kernelID, "Result", dstTexture);
        computeShader.Dispatch(kernelID, srcTexture.width/8, srcTexture.height/8, 1);

		outputImageMaterial.mainTexture = dstTexture;
	}
}
