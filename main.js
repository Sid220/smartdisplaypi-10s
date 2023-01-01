const { app, BrowserWindow, Menu } = require('electron')
const Store = require('electron-store');
const schema = {
    devmode: {
        type: 'boolean',
        default: false
    }
};

const settings = new Store({schema});

const createWindow = () => {
    const win = new BrowserWindow({
        width: 800,
        height: 600
    })
    let template;
    if (settings.get("devmode") === false) {
        win.kiosk = true
        template = [
            {
                label: 'Loading...',
            }
        ];
    }
    else {
        win.openDevTools();
        template = [
            {
                label: '[DEV MODE]',
                submenu: [
                    {
                        label: 'Toggle Dev Tools',
                        accelerator: 'F12',
                        click: function (item, focusedWindow) {
                            if (focusedWindow) {
                                focusedWindow.toggleDevTools();
                            }
                        }
                    },
                    {
                        label: 'Reload',
                        accelerator: 'CmdOrCtrl+R',
                        click: function (item, focusedWindow) {
                            if (focusedWindow) {
                                focusedWindow.reload();
                            }
                        }
                    },
                    {
                        label: 'Force Reload',
                        accelerator: 'CmdOrCtrl+Shift+R',
                        role: "forceReload"
                    }
                ]
            },
        ];
    }
    let menu = Menu.buildFromTemplate(template);
    Menu.setApplicationMenu(menu);

    win.loadFile('web/index.html')
}
app.whenReady().then(() => {
    createWindow()
})