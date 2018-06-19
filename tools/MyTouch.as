package tools
{
    import flash.geom.*;

    final public class MyTouch extends Object
    {
        public var x:Number;
        public var y:Number;
        public var id:int;
        public var isIA:Boolean = false;
        public var vZone:MyZone;
        public var vCallback:Function;
        public var vArgs:Object;

        public function MyTouch(param1:Number, param2:Number, param3:int = 0, param4:MyZone = null)
        {
            this.x = param1;
            this.y = param2;
            this.id = param3;
            this.vZone = param4;
            return;
        }// end function

        public function toString() : String
        {
            return "[MyTouch id=" + this.id + " x=" + this.x + " y=" + this.y + "]";
        }// end function

        public function setZone(param1:MyZone) : void
        {
            this.vZone = param1;
            return;
        }// end function

        public function setCallback(param1:Function) : void
        {
            this.vCallback = param1;
            return;
        }// end function

        public function setArgs(param1:Object) : void
        {
            this.vArgs = param1;
            return;
        }// end function

        public function isHit(param1:MyTouch) : Boolean
        {
            if (this.vZone == null)
            {
                return false;
            }
            return this.vZone.isHit(this, param1);
        }// end function

        public function isInRect(param1:Rectangle) : Boolean
        {
            if (this.x < param1.x)
            {
                return false;
            }
            if (this.x > param1.x + param1.width)
            {
                return false;
            }
            if (this.y < param1.y)
            {
                return false;
            }
            if (this.y > param1.y + param1.height)
            {
                return false;
            }
            return true;
        }// end function

        public static function distance(param1:MyTouch, param2:MyTouch) : Number
        {
            return Math.sqrt((param1.x - param2.x) * (param1.x - param2.x) + (param1.y - param2.y) * (param1.y - param2.y));
        }// end function

    }
}
