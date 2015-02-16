var app = angular.module('app', []);

app.service('websvc', function($http){
	this.exec = function(cmd, val){
		return $http.get('./api?cmd=' + cmd + '&val=' + val);
	}
	
	this.query = function(cmd){
		return $http.get('./sql?cmd=' + cmd);
	}
});

app.controller('AppCtrl', function($scope, websvc){
		$scope.btn = function(val){
			websvc.exec('btn',val).then(
			function(res){
				console.log(res.data);
			}, 
			function(err){
				console.error(err);
			});
		}
		
		$scope.lvl = function(val){
			websvc.exec('lvl',val).then(
			function(res){
				console.log(res.data);
			}, 
			function(err){
				console.error(err);
			});
		}
		
		$scope.str = function(val){
			websvc.exec('str',val).then(
			function(res){
				console.log(res.data);
			}, 
			function(err){
				console.error(err);
			});
		}
});

app.run(function() {
});