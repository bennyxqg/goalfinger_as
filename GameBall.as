package 
{
    import flash.display.*;

    dynamic public class GameBall extends MovieClip
    {
        public var mcLine:MovieClip;
        public var mcTexture:MovieClip;

        public function GameBall()
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
