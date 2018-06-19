package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class PersoFormGraf extends MovieClip
    {
        public var mcMore:MovieClip;
        public var mcEnergy:MovieClip;
        public var mcPerso:MovieClip;
        public var mcMask:MovieClip;
        public var mcBG:MovieClip;
        public var mcPersoCenter:MovieClip;
        public var txtAdd1:TextField;
        public var txtAdd2:TextField;
        public var txtAdd3:TextField;
        public var mc1:MovieClip;
        public var mc2:MovieClip;
        public var txtName:TextField;
        public var mc3:MovieClip;
        public var mcStatus:PersoFormGrafStatus;
        public var mcMoreRecuperation:MovieClip;
        public var mcTimer:MovieClip;

        public function PersoFormGraf()
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
