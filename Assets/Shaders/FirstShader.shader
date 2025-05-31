Shader "Unlit/FirstShader"
{
    Properties
    {
        _Value ("Value", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _Value;

            // automatically filled out by Unity 
            struct MeshData
            {
                float4 vertex : POSITION; //Vertex Position - положение вершин
                float3 normals : NORMAL;
                float4 tangent : TANGENT;
                float4 color : COLOR;
                
                float2 uv0 : TEXCOORD0; //ui coordinates
                float2 uv1 : TEXCOORD1;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION; //Position in clip space - Позиция в пространстве клипов
                //float2 uv : TEXCOORD0; //
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); //local space to clip space 
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                return float4(1, 0, 0, 1);
            }
            ENDCG
        }
    }
}
