/**
 * Calculate the size of a HashMap
 * @param obj
 * @return {number}
 */
function mapSize(obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) {
            size++;
        }
    }
    return size;
}

/**
 * returns true if we can submit the widgets to the user
 * A user can by-pass teh javascript but poses no security thread
 * @param userWidgets
 * @return {boolean}
 */
function canSubmitWidgets(userWidgets, min, max) {

    var canSubmit = true;
    if (mapSize(map) > maximumNumberOfWidgets) {
        canSubmit = false;
    } else if (mapSize(map) < minimumNumberOfWidgets) {
        canSubmit = false;
    }

    return canSubmit;
}

/**
 * add/remove a widget to the list of widgets a user want's to add
 * @param event
 * @param map
 * @param checkbox
 * @param node
 * @param path
 * @return {*}
 */
function addRemoveWidget(event, map, checkbox, node, path) {
    if ($(checkbox).is(":checked")) {
        map[node] = path;
    } else {
        delete map[node];
    }
    return map;
}

/**
 * Updated display of selectWidget
 * @param userWidgets
 * @param displayWarningMessages
 */
function updateSelectDisplay(userWidgets, displayWarningMessages) {
    var numWidgets = mapSize(userWidgets);

    if (numWidgets < minimumNumberOfWidgets) {
        if (displayWarningMessages) {
            $('#minimumReached').show();
        }
        $('#submitWidgets').prop('disabled', true);
    } else if (numWidgets > maximumNumberOfWidgets) {
        if (displayWarningMessages) {
            $('#maximumReached').show();
        }
        $('#submitWidgets').prop('disabled', true);
    } else {
        $('#minimumReached').hide();
        $('#maximumReached').hide();
        $('#submitWidgets').prop('disabled', false);
    }
}

function submitAddWidgets(userWidgets, columns) {
    addWidgetsToUser(userWidgets, columns);
}
function submitResetWidgets(userWidgets) {
    resetWidgetsFromUser();
}

function fixWidgetHeight(widgetWrapper) {
    $('#columns').each(function () {
        var $this = $(this);
        var currentRow = 0;
        var hasRow = true;
        while (hasRow && currentRow < 15) {
            var height = 0;
            hasRow = false;
            $this.children('.column').each(function () {
                var $this = $(this);

                w1 = $this.find('.' + widgetWrapper + ':eq(' + currentRow + ')')
                if (w1.length > 0) {
                    height = Math.max(w1.height(), height)
                }
            });
            $this.children('.column').each(function () {
                var $this = $(this);

                var w1 = $this.find('.' + widgetWrapper + ':eq(' + currentRow + ')')
                if (w1.length > 0) {
                    w1.height(height);
                    hasRow = true;
                }
            });
            currentRow++;
        }
    });
}

