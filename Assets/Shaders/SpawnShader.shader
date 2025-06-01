Shader "Unlit/SpawnShader"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        
        _ColorStart ("Color Start", Range(0,1) ) = 1
        _ColorEnd ("Color End", Range(0,1)) = 0
        
        _Speed ("Speed", Range(0.1,5)) = 2
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }

        Pass
        {
            
            Cull Off
            ZWrite Off
            Blend One One //additive
            //Blend DstColor Zero //multiply
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU 6.28318530718

            float4 _ColorA;
            float4 _ColorB;

            float _ColorStart;
            float _ColorEnd;
            float _Speed;

            // automatically filled out by Unity 
            struct MeshData
            {
                float4 vertex : POSITION; //Vertex Position - положение вершин
                float3 normals : NORMAL;
                //float4 tangent : TANGENT;
                //float4 color : COLOR;
                
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
                o.uv = v.uv0;
                return o;
            }

            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);
            }

            float4 frag (Interpolators i) : SV_Target
            {
                
                //float t = saturate(InverseLerp(_ColorStart, _ColorEnd, i.uv.x));
                //float outColor = lerp(_ColorA, _ColorB, t);
                //return outColor;
                float xOffset = cos(i.uv.x * TAU * 10) * 0.004f;
                float t = cos((i.uv.y + xOffset - _Time.y * _Speed) * TAU * 5) * 0.5 + 0.5;
                t *= 1-i.uv.y;

                float topBottomRemover = (abs(i.normal.y) < 0.999);
                float waves = t * topBottomRemover;
                float4 gradient = lerp(_ColorA, _ColorB, i.uv.y);
                
                return gradient * waves;
            }
            ENDCG
        }
    }
}
