package 
{
    import flash.display.*;

    dynamic public class WaitingGraf extends MovieClip
    {

        public function WaitingGraf()
        {
            addFrameScript(3, this.frame4);
            return;
        }// end function

        function frame4()
        {
            if (stage == null)
            {
                stop();
            }
            return;
        }// end function

    }
}
