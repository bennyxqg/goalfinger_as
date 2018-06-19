package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class ShopItem extends MovieClip
    {
        public var txtGold:TextField;
        public var mcCard:MovieClip;
        public var txtTitle:TextField;
        public var mcCountDown:MovieClip;

        public function ShopItem()
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
