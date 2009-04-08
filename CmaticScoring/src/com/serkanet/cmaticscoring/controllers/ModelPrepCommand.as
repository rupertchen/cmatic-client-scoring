package com.serkanet.cmaticscoring.controllers {
	import com.serkanet.cmaticscoring.models.AppConfigProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ModelPrepCommand extends SimpleCommand {

		override public function execute(notification:INotification):void {
			facade.registerProxy(new AppConfigProxy());
		}

	}
}
