Shader "Unlit/FirstShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Scale ("UV Scale", Float) = 1
        _Offset ("UV Offset", Float) = 1
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

            float4 _Color;
            float _Scale;
            float _Offset;

            // automatically filled out by Unity 
            struct MeshData
            {
                float4 vertex : POSITION; //Vertex Position - положение вершин
                float3 normals : NORMAL;
                float4 tangent : TANGENT;
                float4 color : COLOR;
                
                float2 uv0 : TEXCOORD0; //ui coordinates
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION; //Position in clip space - Позиция в пространстве клипов
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); //local space to clip space
                o.normal = UnityObjectToWorldNormal(v.normals); // just pass through
                o.uv = (v.uv0 + _Offset) * _Scale;
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                return float4(i.normal, 1);
            }
            ENDCG
        }
    }
}
