package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class PrivateGameScreen extends MovieClip
    {
        public var mcQuit:MovieClip;
        public var bPlay:PlayButton;
        public var txtInput:TextField;
        public var txtTitle:TextField;
        public var txtInvite:TextField;

        public function PrivateGameScreen()
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
