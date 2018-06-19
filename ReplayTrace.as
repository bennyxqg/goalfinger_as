package 
{
    import flash.display.*;

    dynamic public class ReplayTrace extends MovieClip
    {

        public function ReplayTrace()
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
