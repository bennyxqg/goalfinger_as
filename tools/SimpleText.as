package tools
{
    import flash.display.*;
    import globz.*;

    public class SimpleText extends Sprite
    {
        private var vType:int;
        private var vGraf:GrafSimpleText;

        public function SimpleText(param1:DisplayObjectContainer, param2:String, param3:Number, param4:Number, param5:int = 1)
        {
            this.vType = param5;
            this.vGraf = new GrafSimpleText();
            this.setText(param2);
            addChild(this.vGraf);
            x = param3;
            y = param4;
            param1.addChild(this);
            if (this.vType == 3)
            {
                this.vGraf.gotoAndStop(3);
                this.vGraf.txtTitle.htmlText = param2;
            }
            return;
        }// end function

        public function setText(param1:String) : void
        {
            if (this.vType == 3)
            {
                return;
            }
            this.vGraf.txtTitle.width = 400;
            if (this.vType == 2)
            {
                this.vGraf.gotoAndStop(2);
            }
            if (param1 == null)
            {
                param1 = "null";
            }
            this.vGraf.txtTitle.htmlText = param1;
            Global.vLang.checkSans(this.vGraf.txtTitle);
            Toolz.textReduce(this.vGraf.txtTitle);
            this.vGraf.txtTitle.width = this.vGraf.txtTitle.textWidth + 5;
            this.vGraf.txtTitle.x = (-this.vGraf.txtTitle.width) / 2;
            if (this.vType == 2)
            {
                this.vGraf.y = this.vGraf.y - this.vGraf.txtTitle.textHeight / 2;
            }
            return;
        }// end function

        public function setColor(param1:uint) : void
        {
            this.vGraf.txtTitle.textColor = param1;
            return;
        }// end function

        public function getInput() : String
        {
            return this.vGraf.txtTitle.text;
        }// end function

    }
}
