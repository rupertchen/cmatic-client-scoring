package com.serkanet.cmaticscoring.controllers {
	import com.serkanet.cmaticscoring.models.AgeGroupsProxy;
	import com.serkanet.cmaticscoring.models.CompetitorsProxy;
	import com.serkanet.cmaticscoring.models.DivisionsProxy;
	import com.serkanet.cmaticscoring.models.FormsProxy;
	import com.serkanet.cmaticscoring.models.GroupsProxy;
	import com.serkanet.cmaticscoring.models.SexesProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class PrefetchDataCommand extends SimpleCommand {

		override public function execute(notification:INotification):void {
			// When a prefetch is added or removed from here, update ApplicationMediator.TOTAL_PREFETCHES
			// and the notifications it listens for.
			DivisionsProxy(facade.retrieveProxy(DivisionsProxy.NAME)).load();
			SexesProxy(facade.retrieveProxy(SexesProxy.NAME)).load();
			AgeGroupsProxy(facade.retrieveProxy(AgeGroupsProxy.NAME)).load()
			FormsProxy(facade.retrieveProxy(FormsProxy.NAME)).load();
			GroupsProxy(facade.retrieveProxy(GroupsProxy.NAME)).load();
			CompetitorsProxy(facade.retrieveProxy(CompetitorsProxy.NAME)).load();
		}

	}
}
