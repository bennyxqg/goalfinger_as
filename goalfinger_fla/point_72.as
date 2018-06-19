package goalfinger_fla
{
    import flash.display.*;

    dynamic public class point_72 extends MovieClip
    {

        public function point_72()
        {
            addFrameScript(0, this.frame1, 1, this.frame2);
            return;
        }// end function

        function frame1()
        {
            nextFrame();
            visible = false;
            return;
        }// end function

        function frame2()
        {
            stop();
            return;
        }// end function

    }
}
