package 
{
    import flash.display.*;
    import flash.geom.*;

    public class TriangleFace extends MovieClip
    {
        public var mcGraf:MovieClip;
        private var vP1:Point;
        private var vP2:Point;
        private var vP3:Point;
        private var vMatrix:Matrix;
        private var vWidth:Number;
        private var vHeight:Number;

        public function TriangleFace()
        {
            this.vWidth = 100;
            this.vHeight = 100;
            return;
        }// end function

        public function triangle(param1:MovieClip, param2:MovieClip, param3:MovieClip)
        {
            this.vP1 = param1.parent.localToGlobal(new Point(param1.x, param1.y));
            this.vP2 = param2.parent.localToGlobal(new Point(param2.x, param2.y));
            this.vP3 = param3.parent.localToGlobal(new Point(param3.x, param3.y));
            this.vP1 = parent.globalToLocal(this.vP1);
            this.vP2 = parent.globalToLocal(this.vP2);
            this.vP3 = parent.globalToLocal(this.vP3);
            this.vMatrix = new Matrix(1 + (this.vP2.x - this.vP1.x - this.vWidth) / this.vWidth, (this.vP2.y - this.vP1.y) / this.vWidth, (this.vP3.x - this.vP1.x) / this.vHeight, 1 + (this.vP3.y - this.vP1.y - this.vHeight) / this.vHeight, this.vP1.x, this.vP1.y);
            this.transform.matrix = this.vMatrix;
            if ((this.vP2.x - this.vP1.x) * (this.vP3.y - this.vP1.y) - (this.vP2.y - this.vP1.y) * (this.vP3.x - this.vP1.x) > 0)
            {
                visible = true;
            }
            else
            {
                visible = false;
            }
            return;
        }// end function

    }
}
