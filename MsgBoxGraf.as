package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class MsgBoxGraf extends MovieClip
    {
        public var txtGold:TextField;
        public var mcEnergy:MovieClip;
        public var txtCost:TextField;
        public var mcCheckBox:MsgBoxGraf_CheckBox;
        public var mcCard:MovieClip;
        public var txtRarity:TextField;
        public var txtNum:TextField;
        public var mcQuit:MovieClip;
        public var mcCost:MovieClip;
        public var mcGraf:MovieClip;
        public var txtSubtitle:TextField;
        public var mcChar:MovieClip;
        public var mcNo:MovieClip;
        public var mcUpgrade:MovieClip;
        public var txtTitle:TextField;
        public var mcZone:MovieClip;
        public var mcGrafNoSubtext:MovieClip;
        public var mcLine1:MovieClip;
        public var mcLine2:MovieClip;
        public var txtMsg:TextField;
        public var txtConfirm:TextField;
        public var mcYes:MovieClip;

        public function MsgBoxGraf()
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
