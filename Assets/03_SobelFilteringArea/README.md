# Sobel filtering area

ステンシルバッファを使わずに特定の領域にソーベルフィルタを適用する

## Memo 
- [Unity5 Effects](https://github.com/i-saint/Unity5Effects)のMosaic Fieldを参考に実装
- ComputeGrabScreenPosではなくComputeScreenPosを使うと上下反転する（UVのVが反転）

## References
- Unity5 Effects
    - https://github.com/i-saint/Unity5Effects

- ShaderLab: GrabPass - Unityマニュアル
    - https://docs.unity3d.com/ja/2017.4/Manual/SL-GrabPass.html

- UnityのShader勉強8　GrabPass
    - http://haru-android.hatenablog.com/entry/2017/12/20/214146

- 【Unity】【シェーダ】スクリーンに対してテクスチャをマッピングする方法を完全解説する
    - http://light11.hatenadiary.com/entry/2018/06/13/235543
