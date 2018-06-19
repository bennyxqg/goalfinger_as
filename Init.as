package 
{
    import flash.display.*;
    import flash.net.*;
    import globz.*;

    public class Init extends Object
    {
        private var vCallback:Function;

        public function Init(param1:Function)
        {
            this.vCallback = param1;
            if (Global.vResolutionForced)
            {
                Global.vResolution = Global.vResolution / 100;
            }
            this.initGraf();
            return;
        }// end function

        private function initGraf() : void
        {
            var _loc_1:* = null;
            var _loc_4:* = null;
            var _loc_6:* = undefined;
            if (Global.vImages != null)
            {
                for (_loc_6 in Global.vImages)
                {
                    
                    _loc_8[_loc_6].destroyAll();
                    _loc_8[_loc_6] = null;
                }
                Global.vImages = null;
            }
            Global.vImages = new Object();
            var _loc_2:* = new mcToBitmapQueue();
            _loc_8["card_back"] = new mcToBitmapAS3(this.getCardLabel("Back"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["card_AF"] = new mcToBitmapAS3(this.getCardLabel("AF"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["card_AS"] = new mcToBitmapAS3(this.getCardLabel("AS"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["card_AV"] = new mcToBitmapAS3(this.getCardLabel("AV"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["card_PA"] = new mcToBitmapAS3(this.getCardLabel("PA"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["card_PB"] = new mcToBitmapAS3(this.getCardLabel("PB"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["card_PC"] = new mcToBitmapAS3(this.getCardLabel("PC"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["card_BA"] = new mcToBitmapAS3(this.getCardLabel("BA"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["card_BV"] = new mcToBitmapAS3(this.getCardLabel("BV"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["card_SA"] = new mcToBitmapAS3(this.getCardLabel("SA"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["card_SB"] = new mcToBitmapAS3(this.getCardLabel("SB"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["card_SC"] = new mcToBitmapAS3(this.getCardLabel("SC"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["card_E30"] = new mcToBitmapAS3(this.getCardLabel("E30"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["card_E100"] = new mcToBitmapAS3(this.getCardLabel("E100"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["card_TypeA"] = new mcToBitmapAS3(this.getCardLabel("TypeA"), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["particle_ball"] = new mcToBitmapAS3(new particle_ball(), 0, Global.vResolution, true, null, 0, _loc_2, 64);
            _loc_8["particle_coin"] = new mcToBitmapAS3(new particle_coin(), 0, Global.vResolution, true, null, 0, _loc_2, 64);
            _loc_8["particle_confetti"] = new mcToBitmapAS3(new particle_confetti(), 0, Global.vResolution, true, null, 0, _loc_2, 64);
            _loc_8["particle_medal"] = new mcToBitmapAS3(new particle_medal(), 0, Global.vResolution, true, null, 0, _loc_2, 64);
            _loc_8["particle_star"] = new mcToBitmapAS3(new particle_star(), 0, Global.vResolution, true, null, 0, _loc_2, 64);
            _loc_8["particle_line_1"] = new mcToBitmapAS3(new particle_line_1(), 0, Global.vResolution, true, null, 0, _loc_2, 64);
            _loc_8["particle_line_2"] = new mcToBitmapAS3(new particle_line_2(), 0, Global.vResolution, true, null, 0, _loc_2, 64);
            _loc_8["particle_line_3"] = new mcToBitmapAS3(new particle_line_3(), 0, Global.vResolution, true, null, 0, _loc_2, 64);
            _loc_8["particle_smoke"] = new mcToBitmapAS3(new particle_smoke(), 0, Global.vResolution, true, null, 0, _loc_2, 64);
            _loc_8["particle_grass"] = new mcToBitmapAS3(new particle_grass(), 0, Global.vResolution, true, null, 0, _loc_2, 64);
            _loc_8["icon_xp"] = new mcToBitmapAS3(new XPIcon(), 0, Global.vResolution, true, null, 0, _loc_2, 64);
            _loc_8["icon_trophy"] = new mcToBitmapAS3(new TrophyIcon(), 0, Global.vResolution, true, null, 0, _loc_2, 64);
            _loc_8["icon_gold"] = new mcToBitmapAS3(new GoldIcon(), 0, Global.vResolution, true, null, 0, _loc_2, 64);
            _loc_8["sparkle"] = new mcToBitmapAS3(new PackSparkleAnimation(), 0, Global.vResolution, true, null, 0, _loc_2, 0, true);
            _loc_8["sparkle_alt"] = new mcToBitmapAS3(new PackSparkleAnimationAlt(), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["light_anim"] = new mcToBitmapAS3(new PackLightAnimation(), 0, Global.vResolution, true, null, 0, _loc_2);
            var _loc_3:* = new MapMonde();
            _loc_3.gotoAndStop(getMapZone());
            _loc_1 = new MovieClip();
            _loc_1.addChild(_loc_3);
            _loc_8["mapmonde"] = new mcToBitmapAS3(_loc_1, 0, Global.vResolution, true, null, 0, _loc_2);
            var _loc_5:* = 0;
            while (_loc_5 < 10)
            {
                
                _loc_4 = new FontGold();
                _loc_4.txt.text = _loc_5.toString();
                _loc_8["fontgold_" + _loc_5] = new mcToBitmapAS3(_loc_4, 0, Global.vResolution * 4, true, null, 0, _loc_2);
                _loc_4 = new FontXPTitle();
                _loc_4.txt.text = _loc_5.toString();
                _loc_8["fontxptitle_" + _loc_5] = new mcToBitmapAS3(_loc_4, 0, Global.vResolution * 4, true, null, 0, _loc_2);
                _loc_4 = new FontXPInside();
                _loc_4.txt.text = _loc_5.toString();
                _loc_8["fontxpinside_" + _loc_5] = new mcToBitmapAS3(_loc_4, 0, Global.vResolution * 4, true, null, 0, _loc_2);
                _loc_4 = new FontEnergyOn();
                _loc_4.gotoAndStop((_loc_5 + 1));
                _loc_1 = new MovieClip();
                _loc_1.addChild(_loc_4);
                _loc_8["fontenergyon_" + _loc_5] = new mcToBitmapAS3(_loc_1, 0, Global.vResolution * 2, true, null, 0, _loc_2);
                _loc_4 = new FontEnergyOff();
                _loc_4.gotoAndStop((_loc_5 + 1));
                _loc_1 = new MovieClip();
                _loc_1.addChild(_loc_4);
                _loc_8["fontenergyoff_" + _loc_5] = new mcToBitmapAS3(_loc_1, 0, Global.vResolution * 1, true, null, 0, _loc_2);
                _loc_5++;
            }
            _loc_4 = new FontXPInside();
            _loc_4.txt.text = "/";
            _loc_8["fontxpinside_/"] = new mcToBitmapAS3(_loc_4, 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["energybarbg"] = new mcToBitmapAS3(new EnergyBarZapBG(), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_8["reconnecting"] = new mcToBitmapAS3(new ReconnectingGraf(), 0, Global.vResolution, true, null, 0, _loc_2);
            _loc_2.startConversion(this.onGrafDone);
            return;
        }// end function

        private function getCardLabel(param1:String) : MovieClip
        {
            var _loc_2:* = new CardGraf();
            _loc_2.mcFG.visible = false;
            if (param1.substr(0, 1) == "E")
            {
                _loc_2.gotoAndStop("Energy");
                _loc_2.txtValue.text = "+" + param1.substr(1);
            }
            else
            {
                _loc_2.gotoAndStop(param1);
            }
            var _loc_3:* = new MovieClip();
            _loc_3.addChild(_loc_2);
            return _loc_3;
        }// end function

        private function onGrafDone() : void
        {
            this.initOptions();
            this.vCallback.call();
            return;
        }// end function

        public function initOptions() : void
        {
            var _loc_1:* = SharedObject.getLocal(Global.SO_ID);
            if (_loc_1.data.ergo < 0)
            {
                Global.vErgoReverse = true;
            }
            else
            {
                Global.vErgoReverse = false;
            }
            if (_loc_1.data.fake_level != null)
            {
                Global.vFakeLevel = _loc_1.data.fake_level;
            }
            return;
        }// end function

        public static function getMapZone() : int
        {
            var _loc_1:* = new Date();
            var _loc_2:* = (-_loc_1.getTimezoneOffset()) / 60;
            if (_loc_2 < -2)
            {
                return 2;
            }
            if (_loc_2 > 3)
            {
                return 3;
            }
            return 1;
        }// end function

    }
}
