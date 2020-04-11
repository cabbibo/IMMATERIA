using UnityEngine;
using System.Collections;

namespace IMMATERIA{
public class AudioListenerTexture : Form
{

    private int width; // texture width
    private int height; // texture height
    private Color backgroundColor = Color.black;
    //public Color waveformColor = Color.green;
    public int size = 1024; // size of sound segment displayed in texture

    private Color[] blank; // blank image array
    public Texture2D texture;
    public float[] samples; // audio samples array
    public float[] lowRes;
    public int lowResSize;// = 256;

    public ComputeBuffer _buffer;

    public Color[] pixels;

    public override void SetStructSize(){
      structSize = 4;
    }

    public override void SetCount(){
      count = size * 2;
    }

    public override void Create()
    {
        width = size;
        height = 1;

        // create the samples array
        samples = new float [ size * 8 ];
        lowRes = new float [ 64 ];
        lowResSize = 64;

        // create the AudioTexture and assign to the guiTexture:
        texture = new Texture2D ( width, height );
        pixels = texture.GetPixels(0,0,width,1 );

        // create a 'blank screen' image
        blank = new Color [ width * height ];

        for ( int i = 0; i < blank.Length; i++ ){
            blank [ i ] = backgroundColor;
        }

        // refresh the display each 100mS
    }



    public override void WhileLiving( float v ){

        AudioListener.GetSpectrumData ( samples, 0, FFTWindow.Triangle );
        pixels = texture.GetPixels(0,0,width,1 );
        for ( int i = 0; i < size; i++ )
        {

            pixels [ i ].r = pixels [ i ].r * .8f + samples [ ( int ) ( i * 4 ) + 0 ] * 128;
            pixels [ i ].g = pixels [ i ].g * .8f + samples [ ( int ) ( i * 4 ) + 1 ] * 128;
            pixels [ i ].b = pixels [ i ].b * .8f + samples [ ( int ) ( i * 4 ) + 2 ] * 128;
            pixels [ i ].a = pixels [ i ].a * .8f + samples [ ( int ) ( i * 4 ) + 3 ] * 128;

        }   

        texture.SetPixels ( pixels );
        texture.Apply();

        SetData( samples );
        Shader.SetGlobalTexture( "_AudioMap" , texture );
    }

}}