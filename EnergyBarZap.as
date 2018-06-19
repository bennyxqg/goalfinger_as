package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class EnergyBarZap extends MovieClip
    {
        public var mcBG:EnergyBarZapBG;
        public var mcRed:MovieClip;
        public var mcValue:MovieClip;
        public var txtValueOn:TextField;
        public var mcYellow:MovieClip;
        public var txtValueOff:TextField;
        public var mcBar:MovieClip;

        public function EnergyBarZap()
        {
            addFrameScript(0, this.frame1);
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

    }
}
