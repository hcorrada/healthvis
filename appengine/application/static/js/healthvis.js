function HVSocket() {
    this._socket = null;
    this._requestId = 0;
    this._callbacks = {};
    this._requestsStack = [];
}

HVSocket.instance = new HVSocket();
HVSocket.prototype.initialize = function(host) {
    if (host == 'None') {
        return;
    }

    try {
        var socket = new WebSocket(host);
        var self = this;

        socket.onopen = function() {self._onSocketOpen();};
        socket.onmessage = function(msg) {self._onSocketMsg(msg);};
        socket.onclose = function() {self._onSocketClose();};

        this._socket = socket;
    } catch(ex) {
        console.log(ex);
    }
};

HVSocket.prototype._onSocketOpen = function() {
    console.log("Socket connected\n");
    for (var i=0; i<this._requestsStack.length; ++i) {
        this._socket.send(this._requestsStack[i]);
    }

    this._requestsStack = [];
};

HVSocket.prototype._onSocketClose = function() {
    this._socket = null;
};

HVSocket.prototype._onSocketMsg = function(msg) {
    console.log('Socket received: ' + msg.data);

    var message = JSON.parse(msg.data);
    if (message.type == 'response') {
        var callback = this._callbacks[message.id];
        delete this._callbacks[message.id];
        callback(JSON.parse(message.data));
    } else if (message.type == 'request') {

    }
};

HVSocket.prototype.connected = function() {
    return (this._socket != null);
};

HVSocket.prototype._nextId = function() {
    return this._requestId++;
};

HVSocket.prototype.sendRequest = function(data, callback) {
    var id = this._nextId();
    this._callbacks[id] = callback;
    var message = {
        type: 'request',
        id: id,
        data: data
    };

    var msg = JSON.stringify(message);
    console.log("Socket sending");
    console.dir(message.data);
    if (this._socket.readyState) {
        this._socket.send(msg);
    } else {
        console.log("Pushed to stack");
        this._requestsStack.push(msg);
    }
};

function Healthvis()  {
    this._renderer = null;
    this._paramsURL = null;
    this._socket = null;
    this._saved = null;
}


Healthvis.instance = new Healthvis();

Healthvis.prototype.initialize = function(saved, url) {
    this._saved = saved;
    if (!saved) {
        this._socket = HVSocket.instance;
        this._socket.initialize(url);
    } else {
        this._paramsURL = url;
    }
};

Healthvis.prototype.register = function (fn) {
        this._renderer = fn;
};

Healthvis.prototype.visualize = function(elementId) {
        var renderer = this._renderer,
            self = this;

        var callback = function(json) {
            renderer.init(elementId, json);
            renderer.visualize();

            if (document.location.search.length) {
                var newcov = $('#covariate-form').serializeArray();
                self.update(newcov);
            }
        };

        if (this._saved) {
            d3.json(this._paramsURL, callback);
        } else {
            this._getParams(callback);
        }
};

Healthvis.prototype._getParams = function(callback) {
    var message = {
        action: 'getParams'
    }
    this._socket.sendRequest(message, callback);
};

Healthvis.prototype._savePlot = function(url, uploadURL) {
    var self = this;

    var callback = function(json) {
        self._stopServer();
        window.location.replace('/display/' + json.id + window.location.search);
    };

    this.initialize(false, url);
    var message = {
        action: 'savePlot',
        data: uploadURL
    }
    this._socket.sendRequest(message, callback);
};

Healthvis.prototype._stopServer = function() {
    var message = {
        action: 'stopServer',
        data: ''
    }
    this._socket.sendRequest(message, function() {})
};

Healthvis.prototype.update = function(formInput) {
        this._renderer.update(formInput);
};

var healthvis = Healthvis.instance;

$(document).ready(function () {
    $('#covariate-form :input').change(function () {
        if ($('#covariate-form').valid()) {
            var newcov = $('#covariate-form').serializeArray();
            healthvis.update(newcov);
        } else {
            console.log('Not valid')
        }
    });

    $('#main').on('custom', function() {

    });
});

