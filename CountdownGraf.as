package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class CountdownGraf extends MovieClip
    {
        public var txtTime:TextField;
        public var mcClock:MovieClip;
        public var mcBar:MovieClip;

        public function CountdownGraf()
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
