package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class HistoryGamesScreen extends MovieClip
    {
        public var mcQuit:MovieClip;
        public var txtInfo:TextField;
        public var txtTitle:TextField;
        public var mcBehind2:MovieClip;
        public var mcBehind1:MovieClip;
        public var mcFront2:MovieClip;
        public var mcFront1:MovieClip;

        public function HistoryGamesScreen()
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
