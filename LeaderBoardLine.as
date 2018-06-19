package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class LeaderBoardLine extends MovieClip
    {
        public var mcCup:MovieClip;
        public var mcBG:MovieClip;
        public var txtTrophy:TextField;
        public var txtRank:TextField;
        public var txtLevel:TextField;
        public var txtUsername:TextField;

        public function LeaderBoardLine()
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
