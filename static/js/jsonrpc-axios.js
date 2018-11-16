/*
    Xenocider 2018
    depend on axios.js
    **sample
    const server = JsonRpc('/api');
    server.test(args).then(callback).catch(failcallback);
*/

function JsonRpc(url) {
    return new Proxy(() => {}, {
        get: function (target, method, receiver) {
            return function () {
                var json_data = {
                    jsonrpc: '2.0',
                    method: method,
                    params: Array.prototype.slice.call(arguments),
                    id: Math.floor(Math.random() * 9999)
                };
                return new Promise(function (resolve, reject) {
                    axios.post(url, json_data).then(response => {
                        if (response.data.hasOwnProperty('result'))
                            resolve(response.data.result);
                        else
                            reject(response.data.error);
                    }).catch(error => reject(error.response.statusText))
                });
            };
        }
    });
}
