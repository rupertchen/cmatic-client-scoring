package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.ApplicationFacade;
	import com.serkanet.cmaticscoring.models.AgeGroupsProxy;
	import com.serkanet.cmaticscoring.models.CompetitorsProxy;
	import com.serkanet.cmaticscoring.models.DivisionsProxy;
	import com.serkanet.cmaticscoring.models.FormsProxy;
	import com.serkanet.cmaticscoring.models.GroupsProxy;
	import com.serkanet.cmaticscoring.models.SexesProxy;

	import flash.events.Event;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;


	public class ApplicationMediator extends Mediator {

		public static const NAME:String = "ApplicationMediator";

		// TODO: move this set of constants to the component
		public static const ID_SCREEN:Number = 1;
		public static const LOADING_SCREEN:Number = 2;
		public static const MAIN_SCREEN:Number = 3;
		public static const ERROR_SCREEN:Number = 4;

		// TODO: This must be manually kept in sync with the number of prefetches in PrefetchDataCommand.
		// Factor this out into a separate prefetch proxy so the command can set the number at the same
		// place it does the loads.
		private static const TOTAL_PREFETCHES:Number = 6;
		private var numPrefetched:Number;


		public function ApplicationMediator(viewComponent:CmaticScoring) {
			super(NAME, viewComponent);

			app.addEventListener(CmaticScoring.ID_SCREEN_CREATED, onIdScreenCreated);
			app.addEventListener(CmaticScoring.LOADING_SCREEN_CREATED, onLoadingScreenCreated);
			app.addEventListener(CmaticScoring.MAIN_SCREEN_CREATED, onMainScreenCreated);
		}


		private function onIdScreenCreated(event:Event):void {
			if (!facade.hasMediator(IdScreenMediator.NAME)) {
				facade.registerMediator(new IdScreenMediator(app.idScreen));
			}
		}


		private function onLoadingScreenCreated(event:Event):void {
			if (!facade.hasMediator(LoadingScreenMediator.NAME)) {
				facade.registerMediator(new LoadingScreenMediator(app.loadingScreen));
			}
		}


		private function onMainScreenCreated(event:Event):void {
			if (!facade.hasMediator(MainScreenMediator.NAME)) {
				facade.registerMediator(new MainScreenMediator(app.mainScreen));
			}
		}


		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.VIEW_ID_SCREEN,
				ApplicationFacade.VIEW_MAIN_SCREEN,

				ConfigProxy.FAILURE,
				ConfigProxy.SUCCESS,

				AgeGroupsProxy.LOAD_SUCCESS,
				CompetitorsProxy.LOAD_SUCCESS,
				DivisionsProxy.LOAD_SUCCESS,
				FormsProxy.LOAD_SUCCESS,
				GroupsProxy.LOAD_SUCCESS,
				SexesProxy.LOAD_SUCCESS,

				ApplicationFacade.PREFETCH_DATA
			];
		}


		override public function handleNotification(notification:INotification):void {
			// Cases are sorted approximately in the order we expect them
			switch (notification.getName()) {
				case ApplicationFacade.VIEW_ID_SCREEN:
					app.viewStack.selectedIndex = ID_SCREEN;
					break;
				case ConfigProxy.SUCCESS:
					numPrefetched = 0;
					sendNotification(ApplicationFacade.PREFETCH_DATA);
					break;
				case ConfigProxy.FAILURE:
					app.viewStack.selectedIndex = ERROR_SCREEN;
					break;
				case ApplicationFacade.PREFETCH_DATA:
					app.viewStack.selectedIndex = LOADING_SCREEN;
					break;
				case AgeGroupsProxy.LOAD_SUCCESS:
				case CompetitorsProxy.LOAD_SUCCESS:
				case DivisionsProxy.LOAD_SUCCESS:
				case FormsProxy.LOAD_SUCCESS:
				case GroupsProxy.LOAD_SUCCESS:
				case SexesProxy.LOAD_SUCCESS:
					trace("Prefetched: " + notification.getName());
					numPrefetched++;
					sendNotification(ApplicationFacade.LOADING_STEP, numPrefetched / TOTAL_PREFETCHES * 100);
					if (isPrefetchDone()) {
						sendNotification(ApplicationFacade.VIEW_MAIN_SCREEN);
					}
					break;
				case ApplicationFacade.VIEW_MAIN_SCREEN:
					app.viewStack.selectedIndex = MAIN_SCREEN;
					break;
			}
		}


		private function get app():CmaticScoring {
			return viewComponent as CmaticScoring;
		}


		private function isPrefetchDone():Boolean {
			return TOTAL_PREFETCHES == numPrefetched;
		}

	}
}
