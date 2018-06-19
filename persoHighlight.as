package 
{

    dynamic public class persoHighlight extends MCAnimation
    {

        public function persoHighlight()
        {
            addFrameScript(0, this.frame1, 64, this.frame65);
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame65()
        {
            checkEnd("pulse");
            return;
        }// end function

    }
}
