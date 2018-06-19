package 
{

    dynamic public class PersoGrafSocle_1 extends MCAnimation
    {

        public function PersoGrafSocle_1()
        {
            addFrameScript(0, this.frame1, 32, this.frame33, 39, this.frame40, 65, this.frame66, 89, this.frame90, 134, this.frame135, 158, this.frame159, 181, this.frame182);
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

        function frame40()
        {
            checkEnd("shown");
            return;
        }// end function

        function frame66()
        {
            checkEnd("fall_up");
            return;
        }// end function

        function frame90()
        {
            checkEnd("fall_down");
            return;
        }// end function

        function frame135()
        {
            checkEnd("win");
            return;
        }// end function

        function frame159()
        {
            checkEnd("lose");
            return;
        }// end function

        function frame182()
        {
            checkEnd("lose");
            return;
        }// end function

    }
}
