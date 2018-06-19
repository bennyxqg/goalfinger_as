package 
{

    dynamic public class PersoGrafSocle_2 extends MCAnimation
    {

        public function PersoGrafSocle_2()
        {
            addFrameScript(0, this.frame1, 32, this.frame33, 38, this.frame39, 62, this.frame63, 86, this.frame87, 131, this.frame132, 155, this.frame156, 179, this.frame180);
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame33()
        {
            checkEnd("show");
            return;
        }// end function

        function frame39()
        {
            checkEnd("shown");
            return;
        }// end function

        function frame63()
        {
            checkEnd("fall_up");
            return;
        }// end function

        function frame87()
        {
            checkEnd("fall_down");
            return;
        }// end function

        function frame132()
        {
            checkEnd("win");
            return;
        }// end function

        function frame156()
        {
            checkEnd("lose");
            return;
        }// end function

        function frame180()
        {
            checkEnd("lose");
            return;
        }// end function

    }
}
