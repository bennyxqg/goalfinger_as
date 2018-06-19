package tools
{

    final public class MyZone extends Object
    {
        public var vType:int;
        public var vWidth:Number;
        public var vHeight:Number;
        private var vWidthHalf:Number;
        private var vHeightHalf:Number;
        private var vRadius2:Number;
        public static const TYPE_CENTER:uint = 1;
        public static const TYPE_TOPLEFT:uint = 2;
        public static const TYPE_RADIAL:uint = 3;

        public function MyZone(param1:int, param2:int, param3:int = 0)
        {
            this.vType = param1;
            this.vWidth = param2;
            this.vHeight = param3;
            if (this.vType == TYPE_RADIAL)
            {
                this.vRadius2 = param2 / 2 * (param2 / 2);
            }
            else
            {
                this.vWidthHalf = this.vWidth / 2;
                this.vHeightHalf = this.vHeight / 2;
            }
            return;
        }// end function

        public function isHit(param1:MyTouch, param2:MyTouch) : Boolean
        {
            if (this.vType == TYPE_CENTER)
            {
                if (param2.x > param1.x + this.vWidthHalf)
                {
                    return false;
                }
                if (param2.y > param1.y + this.vHeightHalf)
                {
                    return false;
                }
                if (param2.x < param1.x - this.vWidthHalf)
                {
                    return false;
                }
                if (param2.y < param1.y - this.vHeightHalf)
                {
                    return false;
                }
            }
            else if (this.vType == TYPE_TOPLEFT)
            {
                if (param2.x > param1.x + this.vWidth)
                {
                    return false;
                }
                if (param2.y > param1.y + this.vHeight)
                {
                    return false;
                }
                if (param2.x < param1.x)
                {
                    return false;
                }
                if (param2.y < param1.y)
                {
                    return false;
                }
            }
            else if (this.vType == TYPE_RADIAL)
            {
                if ((param1.x - param2.x) * (param1.x - param2.x) + (param1.y - param2.y) * (param1.y - param2.y) > this.vRadius2)
                {
                    return false;
                }
            }
            return true;
        }// end function

    }
}
