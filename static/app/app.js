import angular from "angular";
import $ from 'jquery';
import {storage} from '../../bower_components/ngstorage/ngStorage';
import {Draggable} from '../../bower_components/ngDraggable/ngDraggable';


var app = angular.module("app", ["ngStorage", 'ngDraggable']);
export {app};
