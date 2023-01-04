const constants = {
    root: require('electron-root-path').rootPath
}
const Store = require('electron-store');
const schema = {
    devmode: {
        type: 'boolean',
        default: false,
    },
    name: {
        type: 'string',
        default: 'Vestal'
    },
    time: {
        type: 'number',
        default: 30000
    },
    weather: {
        type: 'boolean',
        default: false
    },
    weatherkey: {
        type: 'string',
        default: 'null'
    }
};
const settings = new Store({schema});

function navigate(url, file=true) {
    const webview = document.getElementById('mainwebview');
    if (file) {
        webview.loadURL("file://" + constants.root + "/web/" + url);
    }
    else {
        webview.loadURL(url);
    }
    document.getElementById("webview-container").style.display = "block";
}
function exitApp() {
    const webview = document.getElementById('mainwebview');
    webview.loadURL("about:blank");
    document.getElementById("webview-container").style.display = "none";
}
function refreshApp() {
    const webview = document.getElementById('mainwebview');
    webview.reload();
}