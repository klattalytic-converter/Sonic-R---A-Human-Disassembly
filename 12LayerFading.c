#include <srl.hpp>

*(Uint16 *)0x25f800e4=0x0300;               //Colour RAM offset N0-N3
*(Uint16 *)0x25f800e6=0x0001;               //Colour RAM offset R0-SPRITE
*(Uint16 *)0x25f800e8=0x0010;               //Line colour screen enable
*(Uint16 *)0x25f800ea=0x0000;               //Special priority mode
*(Uint16 *)0x25f800ec=0x0470;               //Colour calc Control
*(Uint16 *)0x25f800ee=0x0300;               //Special colour mode

*(Uint16 *)0x25f800f0=0x0304;               //Sprite 0/1 pri
*(Uint16 *)0x25f800f2=0x0303;               //Sprite 2/3 pri
*(Uint16 *)0x25f800f4=0x0303;               //Sprite 4/5 pri
*(Uint16 *)0x25f800f6=0x0303;               //Sprite 6/7 pri
*(Uint16 *)0x25f800f8=0x0502;               //N0-N1 pri
*(Uint16 *)0x25f800fa=0x0307;               //N2-N3 pri
*(Uint16 *)0x25f800fc=0x0002;               //R0 pri
*(Uint16 *)0x25f800fe=0x0000;               //Reserved

*(Uint16 *)0x25f80100=0x181c;               //Mix Ratio sprites 0-1
*(Uint16 *)0x25f80102=0x1014;               //Mix Ratio 2-3
*(Uint16 *)0x25f80104=0x080c;               //Mix Ratio 4-5
*(Uint16 *)0x25f80106=0x0204;               //Mix Ratio 6-7

*(Uint16 *)0x25f80108=0x0000;               //Mix Ratio N0-N1
*(Uint16 *)0x25f8010a=0x0000;               //Mix Ratio N2-N3
*(Uint16 *)0x25f8010c=0x001b;               //Mix Ratio R0
*(Uint16 *)0x25f8010e=0x1010;               //Mix Ratio Line-Back

*(Uint16 *)0x25f80110=0x007f;               //Col Offset enable
*(Uint16 *)0x25f80112=0x0000;               //Col Offset select
*(Uint16 *)0x25f80114=0x0100;               //Col Offset A Red
*(Uint16 *)0x25f80116=0x0100;               //Col Offset A Green
*(Uint16 *)0x25f80118=0x0100;               //Col Offset A Blue
*(Uint16 *)0x25f8011a=0x0100;               //Col Offset B Red
*(Uint16 *)0x25f8011c=0x0100;               //Col Offset B Green
*(Uint16 *)0x25f8011e=0x0100;               //Col Offset B Blue
}

//------------------------------------------------------------------------------------------
//                                                                    Init Island
//------------------------------------------------------------------------------------------ 
static Uint16 pattern[]= {
    0,2,8,10,32,34,40,42,
    4,6,12,14,36,38,44,46,
    16,18,24,26,48,50,56,58,
    20,22,28,30,52,54,60,62,
    };

static Uint8 water[]= {
    0,1,2,3,4,5,255
    };