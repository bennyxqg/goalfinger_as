package tools
{
    import com.greensock.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;

    public class MyLogTrace extends Sprite
    {
        private var vClientTrace:ClientTrace;
        private var vPanel:SlidePanel;
        private var vDir:int = 0;

        public function MyLogTrace()
        {
            this.vClientTrace = new ClientTrace();
            this.vClientTrace.x = Global.vSize.x / 2;
            this.vClientTrace.y = Global.vSize.y / 2;
            Global.adjustPos(this.vClientTrace, -1, -1);
            this.addChild(this.vClientTrace);
            Global.vRoot.layerLogTrace.addChild(this);
            if (Capabilities.isDebugger)
            {
                this.vClientTrace.bQuit.addEventListener(MouseEvent.CLICK, this.toggle);
            }
            else
            {
                this.vClientTrace.bQuit.addEventListener(TouchEvent.TOUCH_TAP, this.toggle);
            }
            visible = false;
            this.toggle();
            this.initScroll();
            return;
        }// end function

        public function toggle(event:Event = null) : void
        {
            Clipboard.generalClipboard.clear();
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, Global.vLogTrace);
            visible = !visible;
            if (visible)
            {
                if (stage == null)
                {
                    Global.vRoot.layerLogTrace = Global.vRoot.newLayer();
                    Global.vRoot.layerLogTrace.addChild(this);
                }
                this.refreshTrace();
                this.vClientTrace.txtTrace.scrollV = this.vClientTrace.txtTrace.maxScrollV;
            }
            else
            {
                this.vClientTrace.txtTrace.text = "";
            }
            return;
        }// end function

        private function refreshTrace(event:Event = null) : void
        {
            this.vClientTrace.txtTrace.text = Global.vLogTrace.substr(Global.vLogTrace.length - 20000);
            if (stage && visible)
            {
                TweenMax.delayedCall(0.2, this.refreshTrace);
            }
            return;
        }// end function

        private function initScroll() : void
        {
            this.vClientTrace.addEventListener(Event.ENTER_FRAME, this.onFrame);
            if (Capabilities.isDebugger)
            {
                this.vClientTrace.bUp.addEventListener(MouseEvent.MOUSE_DOWN, this.goUp);
                this.vClientTrace.bDown.addEventListener(MouseEvent.MOUSE_DOWN, this.goDown);
                this.vClientTrace.addEventListener(MouseEvent.MOUSE_UP, this.goStop);
            }
            else
            {
                this.vClientTrace.bUp.addEventListener(TouchEvent.TOUCH_BEGIN, this.goUp);
                this.vClientTrace.bDown.addEventListener(TouchEvent.TOUCH_BEGIN, this.goDown);
                this.vClientTrace.addEventListener(TouchEvent.TOUCH_END, this.goStop);
            }
            return;
        }// end function

        private function goUp(event:Event) : void
        {
            this.vDir = -1;
            return;
        }// end function

        private function goDown(event:Event) : void
        {
            this.vDir = 1;
            return;
        }// end function

        private function goStop(event:Event) : void
        {
            this.vDir = 0;
            return;
        }// end function

        private function onFrame(event:Event) : void
        {
            if (this.vDir == 0)
            {
                return;
            }
            this.vClientTrace.txtTrace.scrollV = this.vClientTrace.txtTrace.scrollV + this.vDir;
            return;
        }// end function

    }
}
