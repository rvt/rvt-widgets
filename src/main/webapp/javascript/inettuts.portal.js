/*
 * Script from NETTUTS.com [by James Padolsey]
 * @requires jQuery($), jQuery UI & sortable/draggable UI modules
 */

var iNettuts = {
    
    jQuery : $,
    
    settings : {
        columns : '.column',
        widgetSelector: '.widget',
        handleSelector: '.widget-head',
        contentSelector: '.widget-content',
        widgetDefault : {
            movable: true,
            removable: true
        },
        widgetIndividual : {
            intro : {
                movable: false,
                removable: false
            }
        }
    },

    init : function () {
        //this.attachStylesheet('inettuts.js.css');
        //this.addWidgetControls();
        //this.makeSortable();
    },
    
    getWidgetSettings : function (id) {
        var $ = this.jQuery,
            settings = this.settings;
        return (id&&settings.widgetIndividual[id]) ? $.extend({},settings.widgetDefault,settings.widgetIndividual[id]) : settings.widgetDefault;
    },
    
    addWidgetControls : function () {
        var iNettuts = this,
            $ = this.jQuery,
            settings = this.settings;
            
        $(settings.widgetSelector, $(settings.columns)).each(function () {
            var thisWidgetSettings = iNettuts.getWidgetSettings(this.id);
            if (thisWidgetSettings.removable) {
                $('<a href="#" class="remove">CLOSE</a>').mousedown(function (e) {
                    e.stopPropagation();    
                }).click(function () {
                    if(confirm('This widget will be removed, ok?')) {
                        $(this).parents(settings.widgetSelector).animate({
                            opacity: 0    
                        },function () {
                            $(this).wrap('<div/>').parent().slideUp(function () {
                                $(this).remove();
                            });
                        });
                        var data = {};
                        data["jcrMethodToCall"] = "delete";
                        var id = $(this).closest("li").attr("id");
                        data["source"] = id;

                        $.post(baseUrl+id, data, function(result) {
//                            alert("node " + id + " is deleted" + " from tag " + this.parentNode.parentNode.tagName);
                        }, "json");
                    }
                    return false;
                }).appendTo($(settings.handleSelector, this));
            }

        });
    },
    
    attachStylesheet : function (href) {
        var $ = this.jQuery;
        return $('<link href="' + href + '" rel="stylesheet" type="text/css" />').appendTo('head');
    },
    
    makeSortable : function () {
        var iNettuts = this,
            $ = this.jQuery,
            settings = this.settings,
            $sortableItems = (function () {
                var notSortable = '';
                $(settings.widgetSelector,$(settings.columns)).each(function (i) {
                    if (!iNettuts.getWidgetSettings(this.id).movable) {
                        if(!this.id) {
                            this.id = 'widget-no-id-' + i;
                        }
                        notSortable += '#' + this.id + ',';
                    }
                });
                if (notSortable == '') { notSortable = 'noWidgets'; }
                return $('> li:not(' + notSortable + ')', settings.columns);
            })();
        
        $sortableItems.find(settings.handleSelector).css({
            cursor: 'move'
        }).mousedown(function (e) {
            $sortableItems.css({width:''});
            $(this).parent().css({
                width: $(this).parent().width() + 'px'
            });
        }).mouseup(function () {
            if(!$(this).parent().hasClass('dragging')) {
                $(this).parent().css({width:''});
            } else {
                $(settings.columns).sortable('disable');
            }
        });

        $(settings.columns).sortable({
            items: $sortableItems,
            connectWith: $(settings.columns),
            handle: settings.handleSelector,
            placeholder: 'widget-placeholder',
            forcePlaceholderSize: true,
            revert: 300,
            delay: 100,
            opacity: 0.8,
            containment: 'document',
            start: function (e,ui) {
                $(ui.helper).addClass('dragging');
            },
            stop: function (e,ui) {
                $(ui.item).css({width:''}).removeClass('dragging');
                $(settings.columns).sortable('enable');
            },
            beforeStop: function(event, ui) {
                var data = {};
                data["source"]=ui.item[0].id;
                if (ui.placeholder[0].nextSibling && ui.placeholder[0].nextSibling.attributes) {
                    data["target"]= ui.placeholder[0].nextSibling.id;
                    data["action"] = "moveBefore";
                } else if (ui.placeholder[0].nextSibling && ui.placeholder[0].nextSibling.nextSibling) {
                    data["target"]= ui.placeholder[0].nextSibling.nextSibling.id;
                    data["action"] = "moveBefore";
                } else if (ui.placeholder[0].previousSibling) {
                    str = ui.placeholder[0].parentNode.children[0].id;
                    str = str.substr(0,str.lastIndexOf("/"));
                    if (ui.placeholder[0].parentNode.children.length < 3) {
                        str = str.substr(0,str.lastIndexOf("/")) + "/" + ui.placeholder[0].parentNode.id;
                    }
                    data["target"] = str;
                    data["action"] = "moveAfter";
                }

                var pattern = /\/column[0-9]/;
                sourceColumn = data["source"].match(pattern);
                targetColumn = data["target"].match(pattern);
                ui.item[0].id = ui.item[0].id.replace(sourceColumn, targetColumn);
                url = document.URL.substr(0,document.URL.lastIndexOf("/"));
                node = document.URL.substr(document.URL.lastIndexOf("/"),document.URL.substr(document.URL.lastIndexOf("/")).indexOf("."));

                /*
                console&&console.log("sourceColumn:"+sourceColumn);
                console&&console.log("targetColumn:"+targetColumn);
                console&&console.log("url:"+url);
                console&&console.log("node:"+node);
                console&&console.log("source:"+data["source"]);
                console&&console.log("target:"+data["target"]);
                console&&console.log("action:"+data["action"]);
                */

                $.post(url+node+".move.do", data, function(result) {
                    ui.item[0].id= data["target"] + ui.item[0].id.substr(ui.item[0].id.lastIndexOf("/"),ui.item[0].id.length);
                }, "json");
            }
        });
    }
  
};

iNettuts.init();