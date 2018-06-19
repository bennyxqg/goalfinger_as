package 
{
    import flash.display.*;

    dynamic public class MenuButton_Sell extends MovieClip
    {
        public var mcBG:MovieClip;

        public function MenuButton_Sell()
        {
            addFrameScript(0, this.frame1);
            return;
        }// end function

        function frame1()
        {
            this.mcBG.gotoAndStop(3);
            return;
        }// end function

    }
}
