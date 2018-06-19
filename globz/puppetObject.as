package globz
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class puppetObject extends Object
    {
        public var vBitmap:Boolean;
        public var vBitmapIndex:int;
        public var vName:String;
        public var vNBFrames:int;
        public var vMatrixTab:Vector.<Matrix>;
        public var vAlphaTab:Vector.<Number>;
        public var vIndexTab:Vector.<int>;
        public var vLabelsDictionary:Dictionary;
        public var vID:int = -1;
        public var vIDTotal:int;
        public var vPuppetList:Vector.<puppetObject>;
        public var vAnimsList:Vector.<String>;
        public var vAnimsOnceList:Vector.<String>;
        public var vAnimsOnceListTemp:Vector.<String>;
        public var vStayAllFrames:Boolean = false;

        public function puppetObject() : void
        {
            return;
        }// end function

        final public function destroy() : void
        {
            this.vName = null;
            this.vMatrixTab = null;
            this.vAlphaTab = null;
            this.vIndexTab = null;
            this.vLabelsDictionary = null;
            this.vPuppetList = null;
            this.vAnimsList = null;
            this.vAnimsOnceList = null;
            this.vAnimsOnceListTemp = null;
            return;
        }// end function

    }
}
