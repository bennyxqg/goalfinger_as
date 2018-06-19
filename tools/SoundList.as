package tools
{
    import com.greensock.*;
    import flash.media.*;
    import flash.utils.*;

    public class SoundList extends Object
    {
        public var vManager:SoundManager;
        private var vLastOnCoin:int = 0;
        private var vLastOnXP:int = 0;
        private var vLastOnTrophy:int = 0;
        private var vGameLoop:SoundChannel;
        private var vAroundGame:SoundChannel;
        private var vLastDragTick:Number = 0;
        private var vLastOnImpact:int = 0;
        private var vLastOnImpactSoft:int = 0;
        private var vLastOnHitBall:int = 0;
        private var vLastOnImpactWall:int = 0;
        private var vMusicChannel:SoundChannel;
        private var vSaveMusicVolume:Number = 0;
        private var vSaveAroundGameVolume:Number = 0;
        private var vSaveGameLoopVolume:Number = 0;
        public var vDeactivated:Boolean = false;

        public function SoundList()
        {
            this.vManager = new SoundManager();
            this.refreshConfig();
            return;
        }// end function

        public function refreshConfig() : void
        {
            this.vManager.onConfigReady();
            return;
        }// end function

        public function onButton() : void
        {
            this.vManager.playSound(new wav_button02());
            return;
        }// end function

        public function onSlide() : void
        {
            this.vManager.playSound(new wav_slide02());
            return;
        }// end function

        public function onGift() : void
        {
            this.vManager.playSound(new wav_gift02());
            return;
        }// end function

        public function onCoin() : void
        {
            if (getTimer() - this.vLastOnCoin < 80)
            {
                return;
            }
            this.vLastOnCoin = getTimer();
            this.vManager.playSound(new wav_score01(), 0.6);
            return;
        }// end function

        public function onXP() : void
        {
            if (getTimer() - this.vLastOnXP < 80)
            {
                return;
            }
            this.vLastOnXP = getTimer();
            this.vManager.playSound(new wav_score01(), 0.5);
            return;
        }// end function

        public function onTrophy() : void
        {
            if (getTimer() - this.vLastOnTrophy < 80)
            {
                return;
            }
            this.vLastOnTrophy = getTimer();
            this.vManager.playSound(new wav_score01(), 0.5);
            return;
        }// end function

        public function onGameStart() : void
        {
            this.vManager.playSound(new wav_whistle01(), 0.3);
            this.stopAroundGame();
            this.stopGameLoop();
            this.vGameLoop = this.vManager.playSound(new wav_stade02c(), 0.1, 1, this.afterLoopGame);
            return;
        }// end function

        private function afterLoopGame() : void
        {
            if (this.vGameLoop != null)
            {
                if (Global.vGame == null)
                {
                    return;
                }
                this.vGameLoop = this.vManager.playSound(new wav_stade02c(), 0.1, 1, this.afterLoopGame);
            }
            return;
        }// end function

        public function stopGameLoop() : void
        {
            if (this.vGameLoop != null)
            {
                this.vGameLoop.soundTransform.volume = 0;
                this.vGameLoop.stop();
                this.vGameLoop = null;
                this.vAroundGame = null;
            }
            return;
        }// end function

        public function aroundGame() : void
        {
            this.stopGameLoop();
            this.stopAroundGame();
            this.vAroundGame = this.vManager.playSound(new wav_stade03(), 0.1, 1, this.afterAroundGame);
            return;
        }// end function

        private function afterAroundGame() : void
        {
            if (this.vAroundGame != null)
            {
                if (Global.vGame == null || Global.vGame.vRunning == false)
                {
                    this.vAroundGame = null;
                    return;
                }
                this.vAroundGame = this.vManager.playSound(new wav_stade03(), 0.1, 1, this.afterAroundGame);
            }
            return;
        }// end function

        public function stopAroundGame() : void
        {
            if (this.vAroundGame != null)
            {
                this.vAroundGame.soundTransform.volume = 0;
                this.vAroundGame.stop();
                this.vAroundGame = null;
            }
            return;
        }// end function

        public function onPlayerAppear() : void
        {
            this.vManager.playSound(new wav_pop01(), 1.5);
            return;
        }// end function

        public function onGameEnd() : void
        {
            this.vManager.playSound(new wav_whistle_end01(), 0.3);
            return;
        }// end function

        public function onDragTick() : void
        {
            if (Global.vGame == null)
            {
                return;
            }
            if (Global.vGame.vAction == null)
            {
                return;
            }
            if (getTimer() < this.vLastDragTick + 100)
            {
                return;
            }
            this.vLastDragTick = getTimer();
            this.vManager.playSound(new wav_arrow_drag01());
            return;
        }// end function

        public function onGoalWon() : void
        {
            this.vManager.playSound(new wav_point_win01(), 1.5);
            return;
        }// end function

        public function onGoalLost() : void
        {
            this.vManager.playSound(new wav_point_lose02(), 1.5);
            return;
        }// end function

        public function onPlayerFall() : void
        {
            this.vManager.playSound(new wav_fall02(), 1);
            return;
        }// end function

        public function onTimerTick() : void
        {
            this.vManager.playSound(new wav_timer_go01(), 2);
            return;
        }// end function

        public function onSuddenDeathStarted() : void
        {
            this.vManager.playSound(new wav_mort_subite01(), 0.7);
            return;
        }// end function

        public function onImpact(param1:Number) : void
        {
            if (getTimer() - this.vLastOnImpact < 80)
            {
                return;
            }
            var _loc_2:* = 0.1 * param1;
            this.vLastOnImpact = getTimer();
            var _loc_3:* = Math.floor(3 * Math.random());
            if (_loc_3 == 0)
            {
                this.vManager.playSound(new wav_punch02a(), _loc_2);
            }
            else if (_loc_3 == 1)
            {
                this.vManager.playSound(new wav_punch02b(), _loc_2);
            }
            else if (_loc_3 == 2)
            {
                this.vManager.playSound(new wav_punch02c(), _loc_2);
            }
            return;
        }// end function

        public function onImpactSoft(param1:Number) : void
        {
            if (getTimer() - this.vLastOnImpactSoft < 80)
            {
                return;
            }
            var _loc_2:* = 0.1 * param1;
            this.vLastOnImpactSoft = getTimer();
            this.vManager.playSound(new wav_contact02(), _loc_2);
            return;
        }// end function

        public function onHitBall(param1:Number) : void
        {
            if (getTimer() - this.vLastOnHitBall < 80)
            {
                return;
            }
            this.vLastOnHitBall = getTimer();
            var _loc_2:* = 0.6 * param1;
            this.vManager.playSound(new wav_ball01(), _loc_2);
            return;
        }// end function

        public function onImpactWall(param1:Number) : void
        {
            if (getTimer() - this.vLastOnImpactWall < 80)
            {
                return;
            }
            this.vLastOnImpactWall = getTimer();
            this.vManager.playSound(new wav_ball01(), param1 + 0);
            return;
        }// end function

        public function koSFX() : void
        {
            if (getTimer() - this.vLastOnImpact < 80)
            {
                return;
            }
            this.vLastOnImpact = getTimer();
            var _loc_1:* = Math.floor(3 * Math.random());
            if (_loc_1 == 0)
            {
                this.vManager.playSound(new wav_punch02a(), 0.15);
            }
            else if (_loc_1 == 1)
            {
                this.vManager.playSound(new wav_punch02b(), 0.15);
            }
            else if (_loc_1 == 2)
            {
                this.vManager.playSound(new wav_punch02c(), 0.15);
            }
            return;
        }// end function

        public function playMusic(param1:Number) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (this.vManager.vMusicVolume == 0)
            {
                return;
            }
            if (this.vMusicChannel != null)
            {
                _loc_2 = new SoundTransform(param1);
                this.vMusicChannel.soundTransform = _loc_2;
            }
            else
            {
                _loc_3 = new wav_goalfinger02();
                this.vMusicChannel = _loc_3.play(0, 10000, new SoundTransform(param1, 0));
            }
            return;
        }// end function

        public function stopMusic() : void
        {
            if (this.vMusicChannel == null)
            {
                return;
            }
            TweenMax.to(this.vMusicChannel, 1, {volume:0, onComplete:this.killMusic});
            return;
        }// end function

        private function killMusic() : void
        {
            this.vMusicChannel.stop();
            this.vMusicChannel = null;
            return;
        }// end function

        public function afterToggleMusic() : void
        {
            if (this.vManager.vMusicVolume == 0)
            {
                this.killMusic();
            }
            else
            {
                this.playMusic(0.04);
            }
            return;
        }// end function

        public function firework() : void
        {
            var _loc_1:* = int(Math.random() * 5);
            switch(_loc_1)
            {
                case 0:
                {
                    this.vManager.playSound(new wav_fireworks01(), 0.5);
                    break;
                }
                case 1:
                {
                    this.vManager.playSound(new wav_fireworks02(), 0.5);
                    break;
                }
                case 2:
                {
                    this.vManager.playSound(new wav_fireworks03(), 0.5);
                    break;
                }
                case 3:
                {
                    this.vManager.playSound(new wav_fireworks04(), 0.5);
                    break;
                }
                case 4:
                {
                    this.vManager.playSound(new wav_fireworks05(), 0.5);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onDeactivate() : void
        {
            Global.addLogTrace("deactivate vManager.vMusicVolume=" + this.vManager.vMusicVolume + " vMusicChannel=" + this.vMusicChannel + " vAroundGame=" + this.vAroundGame, "SoundList");
            this.vDeactivated = true;
            if (this.vMusicChannel != null)
            {
                this.vSaveMusicVolume = this.vMusicChannel.soundTransform.volume;
                TweenMax.to(this.vMusicChannel, 1, {volume:0});
            }
            if (this.vAroundGame != null)
            {
                this.vSaveAroundGameVolume = this.vAroundGame.soundTransform.volume;
                TweenMax.to(this.vAroundGame, 1, {volume:0});
            }
            if (this.vGameLoop != null)
            {
                this.vSaveGameLoopVolume = this.vGameLoop.soundTransform.volume;
                TweenMax.to(this.vGameLoop, 1, {volume:0});
            }
            return;
        }// end function

        public function onReactivate() : void
        {
            this.vDeactivated = false;
            if (this.vMusicChannel != null)
            {
                TweenMax.to(this.vMusicChannel, 1, {volume:this.vSaveMusicVolume});
            }
            if (this.vAroundGame != null)
            {
                TweenMax.to(this.vAroundGame, 1, {volume:this.vSaveAroundGameVolume});
            }
            if (this.vGameLoop != null)
            {
                TweenMax.to(this.vGameLoop, 1, {volume:this.vSaveGameLoopVolume});
            }
            return;
        }// end function

    }
}
