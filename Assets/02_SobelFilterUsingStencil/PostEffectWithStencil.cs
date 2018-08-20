using UnityEngine;
using UnityEngine.Rendering;

[RequireComponent(typeof(Camera))]
public class PostEffectWithStencil : MonoBehaviour
{
    [SerializeField]
    private Shader _shader;
	
    [SerializeField]
    private int _StencilRef = 1;

	void Start()
	{
		Initialize();
	}

    private void Initialize()
    {
        var camera = GetComponent<Camera>();
		if(camera.allowMSAA || camera.allowHDR)
		{
			Debug.LogError("MSAAまたはHDRがONの状態ではステンシルバッファを使う処理が正常に動作しません");
		}

        var material = new Material(_shader);
		material.SetInt("_StencilRef", _StencilRef);

		var commandBuffer = new CommandBuffer();
		int textureId = Shader.PropertyToID("_PostEffectTempTexture");

		commandBuffer.GetTemporaryRT(textureId, -1, -1);
		commandBuffer.Blit(BuiltinRenderTextureType.CurrentActive, textureId);
		commandBuffer.Blit(textureId, BuiltinRenderTextureType.CurrentActive, material);
		commandBuffer.ReleaseTemporaryRT(textureId);

        camera.AddCommandBuffer(CameraEvent.AfterForwardAlpha, commandBuffer);
    }
}
