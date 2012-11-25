﻿package 
{
	//import
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.events.TouchEvent;
	import flash.net.URLLoader;
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.ui.*;
	
	trace("classes imported");

	public class build1 extends MovieClip
	{
		//set multitouch mode for TouchEvents
		Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT;

		////variable defenition
		
		//local session vars
		private var userID_local:String;
		private var password_local:String;

		//counters
		public var i:Number = 0;
		public var i2:Number = 0;
		public var i3:Number = 0;
		
		//white space remover
		private var rex:RegExp = /[\s\r\n]*/gim;
		
		//session vars
		private var j_session:URLVariables;
		private var j_send:URLRequest;
		private var j_loader:URLLoader;

		//local redirection vars ->
		private var redirectionData:String;
		private var redirectionLoader:URLLoader;
		private var redirectionURLRequest:URLRequest;

		//local redirection vars <-
		private var selectedNumber:String;
		private var numberID:String;

		private var testingArray:Array = ["testing"];

		private var timeRedir:Array = [0,0];//=[active, choice, destination delay,];
		private var busyRedir:Array = [0,0];// =[active, choice, destination];
		private var unregRedir:Array = [0,0];// =[active, choice, destination];
		private var redirChoice:Array = ["","","",];// [timeChoice, busyChoice, unregChoice]
		
		private var dumpRedir:Array = [];
		private var dumpContainer:String;
		private var timeDelay:String;
		//private var selectedPhoneNumberId:Number;

		//redirection post vars
		private var r_vars:URLVariables;
		private var r_send:URLRequest;
		private var r_loader:URLLoader;
		
		//redir regular expressions
		private var optionValue:RegExp = /optionvalue="[0-9]{4,8}"/;
		private var selectedValue:RegExp = /selected="selected">[0-9]{10}/;
		
		private var delaySniffer:RegExp = /(?:phone1|phone3|backupNumber)"value="[0-9]{3,12}/g;
		private var choiceSniffer:RegExp = /<inputtype="radio"name="choice(?:1|3|Backuprouting)"value="[0-9]{0,4}"onclick="controlRedir(?:Normal|Busy|Backup)\(\)(?:"checked="checked"|)/g;
		private var numberSniffer:RegExp = /name="delay1"size="5"value="[0-9]{1,2}/;
		
		private var numberStripper:RegExp = /name="delay1"size="5"value="/;
		private var bloatStripper:RegExp = /(?:phone1|phone3|backupNumber)"value="/g;

		trace("vars built");
		
		public function build1()
		{
			main.saveBtn.btn_txt.text = "Speichern";
  
			//stage aligment
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//bg setup
			main.timeContainer.gotoAndStop(2);
			main.busyContainer.gotoAndStop(4);
			main.unregContainer.gotoAndStop(6);
			
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight;
			
			//main.unregContainer.Text.y = 5;
			//main.unregContainer.Text.height = 40;
			
			//mc placement and scaling
			header.x = stage.stageWidth / 2;
			header.y = stage.stageHeight * 0.19;
			header.scaleX = stage.stageWidth / 320;
			header.scaleY = stage.stageHeight / 480;
			
			login.x = stage.stageWidth / 2;
			login.y = stage.stageHeight * 0.5;
			login.scaleX = stage.stageWidth / 320;
			login.scaleY = stage.stageHeight / 480;

			loginBtn.x = stage.stageWidth / 2;
			loginBtn.y = stage.stageHeight * 0.7;
			loginBtn.scaleX = stage.stageWidth / 320;
			loginBtn.scaleY = stage.stageHeight / 480;

			main.x = stage.stageWidth / 2;
			main.y = stage.stageHeight * 0.3;
			main.scaleX = stage.stageWidth / 320;
			main.scaleY = stage.stageHeight / 480;

			loading.x = stage.stageWidth / 2;
			loading.y = stage.stageHeight * 0.3;
			loading.scaleX = stage.stageWidth / 320;
			loading.scaleY = stage.stageHeight / 480;

			//hide main
			TweenMax.to(main, 0, {alpha:0, y:"+1000"});

			//initial listeners;
			loginBtn.addEventListener(TouchEvent.TOUCH_TAP, transmit);
			main.timeContainer.addEventListener(TouchEvent.TOUCH_TAP, tempHandler);
			main.busyContainer.addEventListener(TouchEvent.TOUCH_TAP, tempHandler2);
			main.unregContainer.addEventListener(TouchEvent.TOUCH_TAP, tempHandler3);
			
			main.timeContainer.selecter.addEventListener(TouchEvent.TOUCH_TAP, targetTest);
			main.busyContainer.selecter.addEventListener(TouchEvent.TOUCH_TAP, targetTest2);
			main.unregContainer.selecter.addEventListener(TouchEvent.TOUCH_TAP, targetTest3);
			
			
			//change menu
			//transmit
			trace("UI built");
			trace("ready for login");
		}
			
			
			//if (unregRedir[1] == 1){main.unregContainer.gotoAndStop(6);main.unregContainer.destination.text = unregRedir[2];}
			//if (unregRedir[1] == 2){main.unregContainer.gotoAndStop(7);main.unregContainer.destination.text = "Falls Endgeräte nicht erreichbar umleiten auf Voicemail"}
		private function targetTest(event:TouchEvent):void
		{
			if(event.target.name == "phoneIcon"){trace(event.target.name);main.timeContainer.gotoAndStop(2);main.timeContainer.destination.text = "";main.timeContainer.Delay.text = "";};
			if(event.target.name == "voicemailIcon"){trace(event.target.name);main.timeContainer.gotoAndStop(3);main.timeContainer.destination.text = "s umleiten auf Voicemail";main.timeContainer.Delay.text = "";};
		}
		
		private function targetTest2(event:TouchEvent):void
		{
			if(event.target.name == "phoneIcon"){main.busyContainer.gotoAndStop(4);main.busyContainer.destination.text = "";};
			if(event.target.name == "voicemailIcon"){main.busyContainer.gotoAndStop(5);main.busyContainer.destination.text = "Falls besetzt umleiten auf Voicemail";};
		}
		
		private function targetTest3(event:TouchEvent):void
		{
			if(event.target.name == "phoneIcon"){};
			if(event.target.name == "voicemailIcon"){};
		}
		
		private function tempHandler(event:TouchEvent):void
		{
			TweenMax.to(main.timeContainer.selecter, 0.2, {y:50, ease:Cubic.easeInOut});
			TweenMax.to(main.busyContainer.selecter, 0.2, {y:0, ease:Cubic.easeInOut});
			TweenMax.to(main.unregContainer.selecter, 0.2, {y:0, ease:Cubic.easeInOut});
			
			TweenMax.to(main.busyContainer, 0.2, {y:50, ease:Cubic.easeInOut});
			TweenMax.to(main.unregContainer, 0.2, {y:100, ease:Cubic.easeInOut});
		}
		
		private function tempHandler2(event:TouchEvent):void
		{
			TweenMax.to(main.timeContainer.selecter, 0.2, {y:0, ease:Cubic.easeInOut});
			TweenMax.to(main.busyContainer.selecter, 0.2, {y:50, ease:Cubic.easeInOut});
			TweenMax.to(main.unregContainer.selecter, 0.2, {y:0, ease:Cubic.easeInOut});
			
			TweenMax.to(main.busyContainer, 0.2, {y:0, ease:Cubic.easeInOut});
			TweenMax.to(main.unregContainer, 0.2, {y:100, ease:Cubic.easeInOut});
		}
		
		private function tempHandler3(event:TouchEvent):void
		{
			TweenMax.to(main.timeContainer.selecter, 0.2, {y:0, ease:Cubic.easeInOut});
			TweenMax.to(main.busyContainer.selecter, 0.2, {y:0, ease:Cubic.easeInOut});
			TweenMax.to(main.unregContainer.selecter, 0.2, {y:50, ease:Cubic.easeInOut});
			
			TweenMax.to(main.busyContainer, 0.2, {y:0, ease:Cubic.easeInOut});
			TweenMax.to(main.unregContainer, 0.2, {y:50, ease:Cubic.easeInOut});
		}

		private function transmit(event:TouchEvent):void
		{

			loginBtn.removeEventListener(TouchEvent.TOUCH_TAP, transmit);
			main.saveBtn.addEventListener(TouchEvent.TOUCH_TAP, transmitRedir);
			TweenMax.to(header, 0.5, {alpha:1, y:-500, ease:Strong.easeInOut});
			TweenMax.to(login, 0.5, {alpha:1, delay:0.1, y:-500, ease:Cubic.easeInOut});
			TweenMax.to(loginBtn, 0.5, {alpha:1, delay:0.2, y:-500, ease:Cubic.easeInOut});
			TweenMax.to(loading, 0.5, {alpha:1, ease:Cubic.easeInOut});
			TweenMax.to(loading.loading, 0.75, {rotation:"-360", ease:Cubic.easeInOut, repeat:-1});

			userID_local = login.userid_txt.text;
			password_local = login.password_txt.text;

			trace(userID_local, password_local);

			j_session = new URLVariables();
			j_send = new URLRequest("https://web.e-fon.ch/portal/j_acegi_security_check");

			j_send.method = URLRequestMethod.POST;
			j_send.data = j_session;

			j_loader = new URLLoader  ;

			j_loader.addEventListener(Event.COMPLETE, completeHandler);

			j_session.j_username = userID_local;
			j_session.j_password = password_local;

			j_loader.load(j_send);

			trace("logging in" );
			function completeHandler(event:Event):void
			{
				trace("log in complete, getting redirection");
				redirectionLoader = new URLLoader();
				redirectionURLRequest = new URLRequest("https://web.e-fon.ch/portal/redirection.html");

				redirectionLoader.addEventListener(Event.COMPLETE, redirectionHandler);

				function redirectionHandler(event:Event):void
				{
					redirectionData = new String(redirectionLoader.data);
					j_loader.removeEventListener(Event.COMPLETE, completeHandler);
					parse();
				}
				redirectionLoader.load(redirectionURLRequest);
			}

		}

		private function parse(event:Event = null):void
		{
			redirectionData = redirectionData.replace(rex,"");
			trace("parsing redirection");

			TweenMax.to(main, 0.5, {motionBlur:true, delay:0.3,alpha:1, y:"-1000", ease:Cubic.easeInOut});
			TweenMax.to(loading, 0.5, {alpha:0, y:-200, ease:Cubic.easeInOut});
			var result:Array = choiceSniffer.exec(redirectionData);

			while (result != null)
			{
				dumpRedir.push(result);
				result = choiceSniffer.exec(redirectionData);
			}

			for each (var dumpVar in dumpRedir)
			{
				dumpContainer = dumpRedir[i2];
				if (dumpContainer.search("checked") != -1)
				{
					if (i2 == 0){timeRedir = [1,1];}
					if (i2 == 1){timeRedir = [1,2];}
					if (i2 == 2){timeRedir = [1,3];}
					if (i2 == 3){busyRedir = [1,1];}
					if (i2 == 4){busyRedir = [1,2];}
					if (i2 == 5){unregRedir = [1,1];}
					if (i2 == 6){unregRedir = [1,2];}
				}
				i2 = i2 + 1;
			}
		
			result = [];
			dumpRedir = [];
			result = delaySniffer.exec(redirectionData);

			while (result != null)
			{
				dumpRedir.push(result);
				result = delaySniffer.exec(redirectionData);
			}

			for each (var delayVar in dumpRedir)
			{
				dumpContainer = dumpRedir[i3];
				dumpContainer = dumpContainer.replace(bloatStripper,"");
				dumpRedir[i3] = dumpContainer;
				if (i3 == 0)
				{
					timeRedir[2] = dumpContainer;
				}

				if (i3 == 1)
				{
					busyRedir[2] = dumpContainer;
				}

				if (i3 == 2)
				{
					unregRedir[2] = dumpContainer;
				}
				i3 = i3 + 1;
			}
			timeDelay = numberSniffer.exec(redirectionData);
			timeRedir.push(timeDelay.replace(numberStripper, ""));
			trace(timeRedir, busyRedir, unregRedir);
			UIflush();
		}

		private function UIflush(event:Event = null):void
		{
			if (timeRedir[0] == 1){main.timeContainer.Check.gotoAndStop(1);}
			if (timeRedir[0] == 0){main.timeContainer.Check.gotoAndStop(2);}
			if (busyRedir[0] == 1){main.busyContainer.Check.gotoAndStop(1);}
			if (busyRedir[0] == 0){main.busyContainer.Check.gotoAndStop(2);}
			if (unregRedir[0] == 1){main.unregContainer.Check.gotoAndStop(1);}
			if (unregRedir[0] == 0){main.unregContainer.Check.gotoAndStop(2);}
			
			if (timeRedir[1] == 1){main.timeContainer.gotoAndStop(2);main.timeContainer.destination.text = timeRedir[2];main.timeContainer.Delay.text = timeRedir[3];}
			if (timeRedir[1] == 2){main.timeContainer.gotoAndStop(3);main.timeContainer.destination.text = "s umleiten auf Voicemail";main.timeContainer.Delay.text = timeRedir[3];}
			if (timeRedir[1] == 3){main.timeContainer.gotoAndStop(3);main.timeContainer.destination.text = "s umleiten auf Fax2Mail";main.timeContainer.Delay.text = timeRedir[3];}
			
			if (busyRedir[1] == 1){main.busyContainer.gotoAndStop(4);main.busyContainer.destination.text = busyRedir[2];}
			if (busyRedir[1] == 2){main.busyContainer.gotoAndStop(5);main.busyContainer.destination.text = "Falls besetzt umleiten auf Voicemail";}
			
			if (unregRedir[1] == 1){main.unregContainer.gotoAndStop(6);main.unregContainer.destination.text = unregRedir[2];}
			if (unregRedir[1] == 2){main.unregContainer.gotoAndStop(7);main.unregContainer.destination.text = "Falls Endgeräte nicht erreichbar umleiten auf Voicemail"}
			
			//main.timeContainer.Text.text = "Nach " + timeRedir[3] + "s umleiten auf " + redirChoice[0];
			//main.busyContainer.Text.text = "Falls besetzt umleiten auf " + redirChoice[1];
			//main.unregContainer.Text.text = "Falls Endgeräte nicht erreichbar umleiten auf " + redirChoice[2];
			trace(redirChoice[1]);
			
		}

		private function transmitRedir(event:TouchEvent):void
		{
			j_loader.load(j_send);

			j_loader.addEventListener(Event.COMPLETE, transmitRedir2);

			function transmitRedir2(event:Event):void
			{

				r_vars = new URLVariables();
				r_send = new URLRequest("https://web.e-fon.ch/portal/redirection.html");

				r_send.method = URLRequestMethod.POST;
				r_send.data = r_vars;

				r_loader = new URLLoader  ;

				r_vars.featureId1 = 0;
				r_vars.featureId2 = 0;
				r_vars.featureId3 = 0;
				r_vars.featureId4 = 0;
				r_vars.featureIdBackuprouting = 0;
				r_vars.featureIdAnonSuppression = 0;
				r_vars.reload = 
				r_vars.selectedPhoneNumberId = 50288;
				r_vars._uml_normal1 = visible;
				r_vars._uml_busy = visible;
				r_vars._uml_backuprouting = visible;
				r_vars._uml_anonSuppression = visible;
				r_vars._uml_manualStatus = visible;
				r_vars._manualStatusPrivate = visible;
				r_vars._uml_calOof = visible;
				r_vars._uml_calBusy = visible;
				trace(r_vars);
				
				//r_loader.load(r_send);
			}
		}
	}
}