package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class HistoryGamesLine extends MovieClip
    {
        public var mcButton1:MovieClip;
        public var txtTrophy1:TextField;
        public var txtScore:TextField;
        public var txtTrophy:TextField;
        public var mcPlay:MovieClip;
        public var txtPlayer2:TextField;
        public var txtStatus:TextField;
        public var mcStatus:MovieClip;
        public var txtPlayer1:TextField;
        public var txtTitle:TextField;
        public var mcTrophy:TrophyIcon;
        public var mcTrophyIcon:TrophyIcon;
        public var mcButton2:MovieClip;
        public var txtTrophy2:TextField;
        public var txtTimeStart:TextField;

        public function HistoryGamesLine()
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
