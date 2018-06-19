package 
{
    import flash.display.*;

    dynamic public class DefaultPackButton extends MovieClip
    {
        public var mcC1:MovieClip;
        public var mcC2:MovieClip;
        public var mcC3:MovieClip;
        public var mcC4:MovieClip;
        public var mcC5:MovieClip;
        public var mcC6:MovieClip;
        public var mcC7:MovieClip;
        public var mcC8:MovieClip;
        public var mcC9:MovieClip;
        public var mcC10:MovieClip;
        public var i:int;
        public var lCard:int;
        public var lFrameList:Array;

        public function DefaultPackButton()
        {
            addFrameScript(0, this.frame1, 1, this.frame2, 9, this.frame10, 10, this.frame11, 18, this.frame19, 19, this.frame20, 27, this.frame28, 28, this.frame29, 37, this.frame38, 38, this.frame39, 47, this.frame48, 48, this.frame49, 60, this.frame61, 61, this.frame62);
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame2()
        {
            stop();
            return;
        }// end function

        function frame10()
        {
            stop();
            this.lFrameList = [2, 3, 4, 5, 6, 7, 8, 10, 11, 20, 21];
            this.i = 1;
            while (this.i <= 10)
            {
                
                this.lCard = int(Math.random() * this.lFrameList.length);
                if (this["mcC" + this.i] != null)
                {
                    this["mcC" + this.i].gotoAndStop(this.lFrameList[this.lCard]);
                }
                this.lFrameList.splice(this.lCard, 1);
                var _loc_1:* = this;
                var _loc_2:* = this.i + 1;
                _loc_1.i = _loc_2;
            }
            return;
        }// end function

        function frame11()
        {
            stop();
            return;
        }// end function

        function frame19()
        {
            stop();
            this.lFrameList = [2, 3, 4, 5, 6, 7, 8, 10, 11, 20, 21];
            this.i = 1;
            while (this.i <= 10)
            {
                
                this.lCard = int(Math.random() * this.lFrameList.length);
                if (this["mcC" + this.i] != null)
                {
                    this["mcC" + this.i].gotoAndStop(this.lFrameList[this.lCard]);
                }
                this.lFrameList.splice(this.lCard, 1);
                var _loc_1:* = this;
                var _loc_2:* = this.i + 1;
                _loc_1.i = _loc_2;
            }
            return;
        }// end function

        function frame20()
        {
            stop();
            return;
        }// end function

        function frame28()
        {
            stop();
            this.lFrameList = [2, 3, 4, 5, 6, 7, 8, 10, 11, 20, 21];
            this.i = 1;
            while (this.i <= 10)
            {
                
                this.lCard = int(Math.random() * this.lFrameList.length);
                if (this["mcC" + this.i] != null)
                {
                    this["mcC" + this.i].gotoAndStop(this.lFrameList[this.lCard]);
                }
                this.lFrameList.splice(this.lCard, 1);
                var _loc_1:* = this;
                var _loc_2:* = this.i + 1;
                _loc_1.i = _loc_2;
            }
            return;
        }// end function

        function frame29()
        {
            stop();
            return;
        }// end function

        function frame38()
        {
            stop();
            this.lFrameList = [2, 3, 4, 5, 6, 7, 8, 10, 11, 20, 21];
            this.i = 1;
            while (this.i <= 10)
            {
                
                this.lCard = int(Math.random() * this.lFrameList.length);
                if (this["mcC" + this.i] != null)
                {
                    this["mcC" + this.i].gotoAndStop(this.lFrameList[this.lCard]);
                }
                this.lFrameList.splice(this.lCard, 1);
                var _loc_1:* = this;
                var _loc_2:* = this.i + 1;
                _loc_1.i = _loc_2;
            }
            return;
        }// end function

        function frame39()
        {
            stop();
            return;
        }// end function

        function frame48()
        {
            stop();
            this.lFrameList = [2, 3, 4, 5, 6, 7, 8, 10, 11, 20, 21];
            this.i = 1;
            while (this.i <= 10)
            {
                
                this.lCard = int(Math.random() * this.lFrameList.length);
                if (this["mcC" + this.i] != null)
                {
                    this["mcC" + this.i].gotoAndStop(this.lFrameList[this.lCard]);
                }
                this.lFrameList.splice(this.lCard, 1);
                var _loc_1:* = this;
                var _loc_2:* = this.i + 1;
                _loc_1.i = _loc_2;
            }
            return;
        }// end function

        function frame49()
        {
            stop();
            return;
        }// end function

        function frame61()
        {
            stop();
            this.lFrameList = [2, 3, 4, 5, 6, 7, 8, 10, 11, 20, 21];
            this.i = 1;
            while (this.i <= 10)
            {
                
                this.lCard = int(Math.random() * this.lFrameList.length);
                if (this["mcC" + this.i] != null)
                {
                    this["mcC" + this.i].gotoAndStop(this.lFrameList[this.lCard]);
                }
                this.lFrameList.splice(this.lCard, 1);
                var _loc_1:* = this;
                var _loc_2:* = this.i + 1;
                _loc_1.i = _loc_2;
            }
            return;
        }// end function

        function frame62()
        {
            stop();
            return;
        }// end function

    }
}
