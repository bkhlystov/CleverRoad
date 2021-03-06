import angular from "angular";
import $ from 'jquery';
import {app} from '../app.js';
import {storage} from '../../../bower_components/ngstorage/ngStorage';
import {Draggable} from '../../../bower_components/ngDraggable/ngDraggable';

app.controller("mainCtrl", ["$rootScope", "$scope", "$log","$localStorage", 
	"$sessionStorage", "$window", 'ngDraggable',
function($rootScope, $scope, $log, $localStorage, $sessionStorage, $window){
	!!$localStorage.Data[0]?'':$localStorage.Data=[];
	//сохранение в локал сторидж
	$scope.dataList = $localStorage.Data;
	//добавление записи
	$scope.addItem = (text, date, city) => {
		$localStorage.Data.push(
			{
				name: text, 
				birthday: date,
				city: city
			});
	}
	//Очистка формы
	$scope.reset = function() {
	    $scope.text = '';
	    $scope.date = '';
	    $scope.city = '';
  	};

	$scope.Get = function () {
        $log.warn($localStorage.Data);
    }

	$scope.selected = null;
        $scope.select = (index)=>{
        	$scope.selected = index;        
        	$log.warn($scope.selected);
        }
    //удаление записи
	$scope.removeItem = (item) => {
		$log.warn($scope.dataList.indexOf(item));
		$scope.dataList.splice($scope.dataList.indexOf(item),1);
	}	
}]);
