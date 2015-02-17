var app = angular.module('app', ['ngRoute', 'mobile-angular-ui']);
app.config(function ($routeProvider) {
	$routeProvider
		.when('/control', {
			templateUrl:    './views/control.html'
		})
		.when('/dialer', {
			templateUrl:    './views/dialer.html'
		})
		.otherwise({
			redirectTo: '/control'
		});
});
app.service('websvc', function ($http) {
	this.exec = function (cmd, val, chn) {
		return $http.get('./api?cmd=' + cmd + '&val=' + val + '&chn=' + chn);
	};
	this.query = function (cmd) {
		return $http.get('./sql?cmd=' + cmd);
	};
});
app.controller('AppCtrl', function ($scope, websvc) {

	$scope.keypad = '';
	$scope.data = {};
	$scope.dialTitle = 'Cisco Dialpad';
	$scope.level = 80;
	$scope.muteState = 'default';
	$scope.btns = {
		mute: 1
	}
	$scope.clr = function() {
		$scope.keypad = '';
	};

	$scope.volCtrl = function(val){
		switch(val){
			case 'U': {
				if($scope.level <= 95){
					$scope.level += 5;
				}
				break;
			}
			case 'D': {
				if($scope.level >= 5){
					$scope.level -= 5;
				}
				break;
			}
			case 'M': {
				if($scope.btns.mute){
					$scope.btns.mute = 0;
					$scope.muteState = 'default';
				} else {
					$scope.btns.mute = 1;
					$scope.muteState = 'danger';
				}
				
				break;
			}
			default: {
				break;
			}
		}
		
		if(val === 'M'){
			websvc.exec('btn', $scope.btns.mute, 8).then(
			function (res) {
				console.log(res.data);
				$scope.data = res.data;
			},
			function (err) {
				console.error(err);
			});
		} else {
			websvc.exec('lvl', $scope.level, 1).then(
			function (res) {
				console.log(res.data);
				$scope.data = res.data;
			},
			function (err) {
				console.error(err);
			});
		}
	}
	
	$scope.btn = function (val) {
		if(val === 'A'){
			$scope.keypad = $scope.keypad + "#";
		}
		else if(val === 'B'){
			$scope.keypad = $scope.keypad + "*";
		} else {
			$scope.keypad = $scope.keypad + val;
		}
	};

	$scope.dial = function(){
		websvc.exec('str', 'DIAL-' + $scope.keypad, 0).then(
			function (res) {
				console.log(res.data);
				$scope.data = res.data;
			},
			function (err) {
				console.error(err);
			});
	};

	$scope.hangup = function(){
		websvc.exec('str', 'HANGUP', 0).then(
			function (res) {
				console.log(res.data);
			},
			function (err) {
				console.error(err);
			});
	};

	$scope.lvl = function (val) {
		websvc.exec('lvl', val).then(
			function (res) {
				console.log(res.data);
			},
			function (err) {
				console.error(err);
			});
	};

	$scope.str = function (val) {
		websvc.exec('str', val).then(
			function (res) {
				console.log(res.data);
			},
			function (err) {
				console.error(err);
			});
	};
});
app.run(function () {

});